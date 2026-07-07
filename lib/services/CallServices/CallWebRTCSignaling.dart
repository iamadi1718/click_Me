import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCSignaling {
  WebRTCSignaling._();

  static final WebRTCSignaling instance = WebRTCSignaling._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //-------------------------------------------------------------
  // Renderers
  //-------------------------------------------------------------

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  //-------------------------------------------------------------
  // Peer Connection
  //-------------------------------------------------------------

  RTCPeerConnection? _peerConnection;

  MediaStream? localStream;
  MediaStream? remoteStream;

  //-------------------------------------------------------------
  // Firestore
  //-------------------------------------------------------------

  DocumentReference<Map<String, dynamic>>? _callDoc;

  StreamSubscription? _callSubscription;
  StreamSubscription? _callerCandidatesSubscription;
  StreamSubscription? _receiverCandidatesSubscription;

  //-------------------------------------------------------------
  // Prevent duplicate ICE candidates
  //-------------------------------------------------------------

  final Set<String> _callerCandidateIds = {};
  final Set<String> _receiverCandidateIds = {};

  //-------------------------------------------------------------
  // Callbacks
  //-------------------------------------------------------------

  VoidCallback? onConnected;
  VoidCallback? onDisconnected;
  Function(String)? onError;

  //-------------------------------------------------------------
  // State
  //-------------------------------------------------------------

  bool _initialized = false;
  bool _remoteDescriptionSet = false;

  bool get isInitialized => _initialized;
  bool get hasConnection => _peerConnection != null;

  //-------------------------------------------------------------
  // STUN
  //-------------------------------------------------------------

  final Map<String, dynamic> configuration = {
    "iceServers": [
      {
        "urls": [
          "stun:stun1.l.google.com:19302",
          "stun:stun2.l.google.com:19302",
        ],
      },
    ],
  };

  //-------------------------------------------------------------
  // Constraints
  //-------------------------------------------------------------

  final Map<String, dynamic> offerConstraints = {
    "mandatory": {"OfferToReceiveAudio": true, "OfferToReceiveVideo": true},
    "optional": [],
  };

  //-------------------------------------------------------------
  // Initialize Renderers
  //-------------------------------------------------------------

  Future<void> initialize() async {
    if (_initialized) return;

    await localRenderer.initialize();
    await remoteRenderer.initialize();

    _initialized = true;
  }

  //-------------------------------------------------------------
  // Local Stream
  //-------------------------------------------------------------

  Future<void> createLocalStream({bool video = true}) async {
   final mediaConstraints = {
  "audio": true,
  "video": video
      ? {
          "facingMode": "user",
          "width": {
            "ideal": 720,
          },
          "height": {
            "ideal": 1280,
          },
          "frameRate": {
            "ideal": 30,
          },
        }
      : false,
}; localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

    localRenderer.srcObject = localStream;
  }

  //-------------------------------------------------------------
  // Create Peer Connection
  //-------------------------------------------------------------

  Future<void> _createPeerConnection() async {
    _peerConnection = await createPeerConnection(configuration);

    //---------------------------------------------------------
    // Add Local Tracks
    //---------------------------------------------------------

    for (final track in localStream!.getTracks()) {
      await _peerConnection!.addTrack(track, localStream!);
    }

    //---------------------------------------------------------
    // Remote Track
    //---------------------------------------------------------

    _peerConnection!.onTrack = (RTCTrackEvent event) async {
      print("========== onTrack ==========");
      print("Track Kind : ${event.track.kind}");
      print("Streams : ${event.streams.length}");

      if (event.streams.isNotEmpty) {
        remoteStream = event.streams.first;
        remoteRenderer.srcObject = remoteStream;
      } else {
        // Some devices don't send streams with onTrack.
        remoteStream ??= await createLocalMediaStream("remote_stream");

        remoteStream!.addTrack(event.track);

        remoteRenderer.srcObject = remoteStream;
      }

      print("Remote renderer updated.");
    };

    //---------------------------------------------------------
    // Connection State
    //---------------------------------------------------------

    _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
      print("Connection State : $state");

      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          onConnected?.call();
          break;

        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          onDisconnected?.call();
          break;

        default:
          break;
      }
    };

    //---------------------------------------------------------
    // ICE Connection State
    //---------------------------------------------------------

    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      print("ICE State : $state");
    };

    //---------------------------------------------------------
    // ICE Gathering
    //---------------------------------------------------------

    _peerConnection!.onIceGatheringState = (RTCIceGatheringState state) {
      print("ICE Gathering : $state");
    };

    //---------------------------------------------------------
    // Signaling
    //---------------------------------------------------------

    _peerConnection!.onSignalingState = (RTCSignalingState state) {
      print("Signaling State : $state");
    };
  }

  //-------------------------------------------------------------
  // Create Call (Caller)
  //-------------------------------------------------------------
  //-------------------------------------------------------------
// Toggle Mic
//-------------------------------------------------------------

Future<void> toggleMic(bool enabled) async {
  if (localStream == null) return;

  for (final track in localStream!.getAudioTracks()) {
    track.enabled = enabled;
  }
}

 //-------------------------------------------------------------
 // Toggle Camera
 //-------------------------------------------------------------

Future<void> toggleCamera(bool enabled) async {
  if (localStream == null) return;

  for (final track in localStream!.getVideoTracks()) {
    track.enabled = enabled;
  }
}

 //-------------------------------------------------------------
 // Speaker
 //-------------------------------------------------------------

Future<void> setSpeaker(bool enabled) async {
  await Helper.setSpeakerphoneOn(enabled);
}

 //-------------------------------------------------------------
 // Switch Camera
 //-------------------------------------------------------------

Future<void> switchCamera() async {
  if (localStream == null) return;

  final videoTracks = localStream!.getVideoTracks();

  if (videoTracks.isEmpty) return;

  await Helper.switchCamera(videoTracks.first);
}
  Future<void> createCall({
    required String callId,
    required bool isVideoCall,
  }) async {
    try {
      if (!_initialized) {
        await initialize();
      }

      _remoteDescriptionSet = false;
      _callerCandidateIds.clear();
      _receiverCandidateIds.clear();

      await createLocalStream(video: isVideoCall);
      await _createPeerConnection();

      _callDoc = _firestore.collection("calls").doc(callId);

      //---------------------------------------------------------
      // Upload Caller ICE
      //---------------------------------------------------------

      _peerConnection!.onIceCandidate = (candidate) async {
        if (candidate.candidate == null) return;

        await _callDoc!.collection("callerCandidates").add(candidate.toMap());
      };

      //---------------------------------------------------------
      // Create Offer
      //---------------------------------------------------------

      final offer = await _peerConnection!.createOffer(offerConstraints);

      await _peerConnection!.setLocalDescription(offer);

      await _callDoc!.set({
        "offer": offer.toMap(),
        "type": isVideoCall ? "video" : "audio",
        "status": "ringing",
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      //---------------------------------------------------------
      // Listen for Answer
      //---------------------------------------------------------

      _callSubscription?.cancel();

      _callSubscription = _callDoc!.snapshots().listen((snapshot) async {
        if (!snapshot.exists) return;

        final data = snapshot.data();

        if (data == null) return;

        if (data["answer"] == null) return;

        if (_remoteDescriptionSet) return;

        try {
          final answer = RTCSessionDescription(
            data["answer"]["sdp"],
            data["answer"]["type"],
          );

          await _peerConnection!.setRemoteDescription(answer);

          _remoteDescriptionSet = true;

          print("Answer received.");
        } catch (e) {
          print("Remote description error : $e");
        }
      });

      //---------------------------------------------------------
      // Listen Receiver ICE
      //---------------------------------------------------------

      _receiverCandidatesSubscription?.cancel();

      _receiverCandidatesSubscription = _callDoc!
          .collection("receiverCandidates")
          .snapshots()
          .listen((snapshot) async {
            for (final change in snapshot.docChanges) {
              if (change.type != DocumentChangeType.added) continue;

              if (_receiverCandidateIds.contains(change.doc.id)) {
                continue;
              }

              _receiverCandidateIds.add(change.doc.id);

              final data = change.doc.data();

              if (data == null) continue;

              try {
                await _peerConnection!.addCandidate(
                  RTCIceCandidate(
                    data["candidate"],
                    data["sdpMid"],
                    data["sdpMLineIndex"],
                  ),
                );
              } catch (e) {
                print("Receiver ICE error : $e");
              }
            }
          });
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  //-------------------------------------------------------------
  // Join Call (Receiver)
  //-------------------------------------------------------------

  Future<void> joinCall({required String callId}) async {
    try {
      if (!_initialized) {
        await initialize();
      }

      _remoteDescriptionSet = false;
      _callerCandidateIds.clear();
      _receiverCandidateIds.clear();

      _callDoc = _firestore.collection("calls").doc(callId);

      //---------------------------------------------------------
      // Wait until offer exists
      //---------------------------------------------------------

      DocumentSnapshot<Map<String, dynamic>> snapshot;

      while (true) {
        snapshot = await _callDoc!.get();

        if (!snapshot.exists) {
          await Future.delayed(const Duration(milliseconds: 300));
          continue;
        }

        final data = snapshot.data();

        if (data != null && data["offer"] != null) {
          break;
        }

        await Future.delayed(const Duration(milliseconds: 300));
      }

      final data = snapshot.data()!;

      final isVideo = data["type"] == "video";

      await createLocalStream(video: isVideo);

      await _createPeerConnection();

      //---------------------------------------------------------
      // Upload Receiver ICE
      //---------------------------------------------------------

      _peerConnection!.onIceCandidate = (candidate) async {
        if (candidate.candidate == null) return;

        await _callDoc!.collection("receiverCandidates").add(candidate.toMap());
      };

      //---------------------------------------------------------
      // Set Remote Offer
      //---------------------------------------------------------

      final offer = RTCSessionDescription(
        data["offer"]["sdp"],
        data["offer"]["type"],
      );

      await _peerConnection!.setRemoteDescription(offer);

      _remoteDescriptionSet = true;

      //---------------------------------------------------------
      // Create Answer
      //---------------------------------------------------------

      final answer = await _peerConnection!.createAnswer();

      await _peerConnection!.setLocalDescription(answer);

      await _callDoc!.update({"answer": answer.toMap(), "status": "connected"});

      print("Answer uploaded.");

      //---------------------------------------------------------
      // Listen Caller ICE
      //---------------------------------------------------------

      _callerCandidatesSubscription?.cancel();

      _callerCandidatesSubscription = _callDoc!
          .collection("callerCandidates")
          .snapshots()
          .listen((snapshot) async {
            for (final change in snapshot.docChanges) {
              if (change.type != DocumentChangeType.added) {
                continue;
              }

              if (_callerCandidateIds.contains(change.doc.id)) {
                continue;
              }

              _callerCandidateIds.add(change.doc.id);

              final data = change.doc.data();

              if (data == null) continue;

              try {
                await _peerConnection!.addCandidate(
                  RTCIceCandidate(
                    data["candidate"],
                    data["sdpMid"],
                    data["sdpMLineIndex"],
                  ),
                );
              } catch (e) {
                print("Caller ICE error : $e");
              }
            }
          });
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  //-------------------------------------------------------------
  // Hang Up
  //-------------------------------------------------------------

  Future<void> hangUp(String callId) async {
    try {
      final callDoc = _firestore.collection("calls").doc(callId);

      //---------------------------------------------------------
      // Delete Caller ICE
      //---------------------------------------------------------

      final callerCandidates =
          await callDoc.collection("callerCandidates").get();

      for (final doc in callerCandidates.docs) {
        await doc.reference.delete();
      }

      //---------------------------------------------------------
      // Delete Receiver ICE
      //---------------------------------------------------------

      final receiverCandidates =
          await callDoc.collection("receiverCandidates").get();

      for (final doc in receiverCandidates.docs) {
        await doc.reference.delete();
      }

      //---------------------------------------------------------
      // Delete Call Document
      //---------------------------------------------------------

      await callDoc.delete();
    } catch (e) {
      print("HangUp Error : $e");
    }

    await dispose();
  }

  //-------------------------------------------------------------
  // Dispose Everything
  //-------------------------------------------------------------

  Future<void> dispose() async {
    _remoteDescriptionSet = false;

    _callerCandidateIds.clear();
    _receiverCandidateIds.clear();

    //---------------------------------------------------------
    // Cancel Firestore Listeners
    //---------------------------------------------------------

    await _callSubscription?.cancel();
    _callSubscription = null;

    await _callerCandidatesSubscription?.cancel();
    _callerCandidatesSubscription = null;

    await _receiverCandidatesSubscription?.cancel();
    _receiverCandidatesSubscription = null;

    //---------------------------------------------------------
    // Close Peer Connection
    //---------------------------------------------------------

    if (_peerConnection != null) {
      try {
        await _peerConnection!.close();
      } catch (_) {}

      try {
        await _peerConnection!.dispose();
      } catch (_) {}

      _peerConnection = null;
    }

    //---------------------------------------------------------
    // Stop Local Stream
    //---------------------------------------------------------

    if (localStream != null) {
      for (final track in localStream!.getTracks()) {
        try {
          track.stop();
        } catch (_) {}
      }

      try {
        await localStream!.dispose();
      } catch (_) {}

      localStream = null;
    }

    //---------------------------------------------------------
    // Stop Remote Stream
    //---------------------------------------------------------

    if (remoteStream != null) {
      for (final track in remoteStream!.getTracks()) {
        try {
          track.stop();
        } catch (_) {}
      }

      try {
        await remoteStream!.dispose();
      } catch (_) {}

      remoteStream = null;
    }

    //---------------------------------------------------------
    // Clear Renderers
    //---------------------------------------------------------

    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;

    _callDoc = null;
  }

  //-------------------------------------------------------------
  // Release Everything
  //-------------------------------------------------------------

  Future<void> release() async {
    await dispose();

    try {
      await localRenderer.dispose();
    } catch (_) {}

    try {
      await remoteRenderer.dispose();
    } catch (_) {}

    _initialized = false;
  }

  //-------------------------------------------------------------
  // Helper Getters
  //-------------------------------------------------------------

  bool get isMicEnabled {
    if (localStream == null) return false;

    if (localStream!.getAudioTracks().isEmpty) {
      return false;
    }

    return localStream!.getAudioTracks().first.enabled;
  }

  bool get isCameraEnabled {
    if (localStream == null) return false;

    if (localStream!.getVideoTracks().isEmpty) {
      return false;
    }

    return localStream!.getVideoTracks().first.enabled;
  }

  bool get hasRemoteVideo {
    return remoteRenderer.srcObject != null;
  }

  bool get hasLocalVideo {
    return localRenderer.srcObject != null;
  }
}
