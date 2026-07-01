import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCSignaling {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // WebRTC Configuration using Google's public STUN servers
  final Map<String, dynamic> _configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
        ]
      }
    ]
  };

  // MediaStream for the local camera and microphone feed
  MediaStream? localStream;

  // Keep track of peer connections (Broadcaster map: viewerId -> connection; Viewer single connection)
  final Map<String, RTCPeerConnection> _peerConnections = {};
  RTCPeerConnection? viewerPeerConnection;

  // Stream controller to notify UI when a remote stream is added (used by viewers)
  final StreamController<MediaStream> _onRemoteStreamController = StreamController<MediaStream>.broadcast();
  Stream<MediaStream> get onRemoteStream => _onRemoteStreamController.stream;

  // Subscriptions to clean up
  StreamSubscription? _viewersSubscription;
  final List<StreamSubscription> _peerSubscriptions = [];

  /// Initialize local camera and microphone media stream
  Future<MediaStream> createLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640', // 480p resolution for mobile compatibility
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    return localStream!;
  }

  /// Broadcaster starts listening for viewers under /live_streams/{streamId}/viewers
  Future<void> startBroadcasting(String streamId) async {
    if (localStream == null) {
      await createLocalStream();
    }

    final viewersCollection = _db.collection('live_streams').doc(streamId).collection('viewers');

    // Clean up any old viewer sessions
    try {
      final oldDocs = await viewersCollection.get();
      for (var doc in oldDocs.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      // Re-throw so caller can handle permission-denied clearly
      throw Exception('Firestore access failed during broadcast setup: $e');
    }

    // Listen for new viewer documents joining the stream
    _viewersSubscription = viewersCollection.snapshots().listen(
      (snapshot) async {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final viewerId = change.doc.id;
            if (!_peerConnections.containsKey(viewerId)) {
              await _setupBroadcasterPeerConnection(streamId, viewerId);
            }
          } else if (change.type == DocumentChangeType.removed) {
            final viewerId = change.doc.id;
            await _removeViewerConnection(viewerId);
          }
        }
      },
      onError: (e) {
        print('Firestore viewer subscription error: $e');
      },
    );
  }

  /// Setup the WebRTC Peer Connection for a specific viewer (Broadcaster side)
  Future<void> _setupBroadcasterPeerConnection(String streamId, String viewerId) async {
    final peerConnection = await createPeerConnection(_configuration);
    _peerConnections[viewerId] = peerConnection;

    // Add local tracks to the peer connection
    localStream?.getTracks().forEach((track) {
      peerConnection.addTrack(track, localStream!);
    });

    final docRef = _db.collection('live_streams').doc(streamId).collection('viewers').doc(viewerId);

    // Send local ICE candidates to Firestore
    peerConnection.onIceCandidate = (candidate) {
      docRef.collection('broadcaster_candidates').add(candidate.toMap());
    };

    // Listen for viewer's remote ICE candidates
    final candidatesSub = docRef.collection('viewer_candidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          peerConnection.addCandidate(
            RTCIceCandidate(data?['candidate'], data?['sdpMid'], data?['sdpMLineIndex']),
          );
        }
      }
    });
    _peerSubscriptions.add(candidatesSub);

    // Create SDP Offer
    final offer = await peerConnection.createOffer({
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': true,
    });
    await peerConnection.setLocalDescription(offer);

    // Write SDP Offer to Firestore
    await docRef.set({'offer': offer.toMap()}, SetOptions(merge: true));

    // Listen for SDP Answer from Viewer
    final answerSub = docRef.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      if (data != null && data['answer'] != null && peerConnection.getRemoteDescription() == null) {
        final answer = RTCSessionDescription(data['answer']['sdp'], data['answer']['type']);
        await peerConnection.setRemoteDescription(answer);
      }
    });
    _peerSubscriptions.add(answerSub);
  }

  /// Viewer starts watching a live stream
  Future<void> startWatching(String streamId, String viewerId) async {
    viewerPeerConnection = await createPeerConnection(_configuration);
    final docRef = _db.collection('live_streams').doc(streamId).collection('viewers').doc(viewerId);

    // Send local viewer ICE candidates to Firestore
    viewerPeerConnection!.onIceCandidate = (candidate) {
      docRef.collection('viewer_candidates').add(candidate.toMap());
    };

    // Listen for broadcaster's remote tracks
    viewerPeerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        _onRemoteStreamController.add(event.streams[0]);
      }
    };

    // Listen for broadcaster's ICE candidates
    final candidatesSub = docRef.collection('broadcaster_candidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          viewerPeerConnection?.addCandidate(
            RTCIceCandidate(data?['candidate'], data?['sdpMid'], data?['sdpMLineIndex']),
          );
        }
      }
    });
    _peerSubscriptions.add(candidatesSub);

    // Listen for SDP Offer from Broadcaster
    final offerSub = docRef.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      if (data != null && data['offer'] != null && viewerPeerConnection?.getRemoteDescription() == null) {
        final offer = RTCSessionDescription(data['offer']['sdp'], data['offer']['type']);
        await viewerPeerConnection?.setRemoteDescription(offer);

        // Create SDP Answer
        final answer = await viewerPeerConnection!.createAnswer({
          'offerToReceiveAudio': true,
          'offerToReceiveVideo': true,
        });
        await viewerPeerConnection?.setLocalDescription(answer);

        // Write SDP Answer to Firestore
        await docRef.set({'answer': answer.toMap()}, SetOptions(merge: true));
      }
    });
    _peerSubscriptions.add(offerSub);

    // Initial dummy write to create the viewer session document in Firestore, triggering the broadcaster's listener
    await docRef.set({'created': FieldValue.serverTimestamp()});
  }

  /// Clean up a single viewer's connection (Broadcaster side)
  Future<void> _removeViewerConnection(String viewerId) async {
    final pc = _peerConnections.remove(viewerId);
    if (pc != null) {
      await pc.close();
    }
  }

  /// Switch between front and back camera
  Future<void> switchCamera() async {
    if (localStream != null) {
      final videoTrack = localStream!.getVideoTracks().firstOrNull;
      if (videoTrack != null) {
        await Helper.switchCamera(videoTrack);
      }
    }
  }

  /// Clean up all WebRTC resources and active Firestore listeners/subscriptions
  Future<void> cleanUp(String? streamId, {String? viewerId}) async {
    // 1. Cancel Firestore subscriptions
    await _viewersSubscription?.cancel();
    _viewersSubscription = null;

    for (var sub in _peerSubscriptions) {
      await sub.cancel();
    }
    _peerSubscriptions.clear();

    // 2. Dispose peer connections
    for (var pc in _peerConnections.values) {
      await pc.close();
    }
    _peerConnections.clear();

    if (viewerPeerConnection != null) {
      await viewerPeerConnection!.close();
      viewerPeerConnection = null;
    }

    // 3. Stop local camera/mic stream tracks
    if (localStream != null) {
      localStream!.getTracks().forEach((track) {
        track.stop();
      });
      await localStream!.dispose();
      localStream = null;
    }

    // 4. Delete viewer session document if viewer
    if (streamId != null && viewerId != null) {
      try {
        await _db
            .collection('live_streams')
            .doc(streamId)
            .collection('viewers')
            .doc(viewerId)
            .delete();
      } catch (e) {
        // Silently catch errors if document already deleted
      }
    }
  }
}
