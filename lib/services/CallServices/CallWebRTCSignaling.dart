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
  // Callbacks
  //-------------------------------------------------------------

  VoidCallback? onConnected;

  VoidCallback? onDisconnected;

  Function(String)? onError;

  //-------------------------------------------------------------
  // State
  //-------------------------------------------------------------

  bool _initialized = false;

  bool get isInitialized => _initialized;

  bool get hasConnection => _peerConnection != null;
  bool _remoteDescriptionSet = false;

  //-------------------------------------------------------------
  // STUN Servers
  //-------------------------------------------------------------

  final Map<String, dynamic> configuration = {
    "iceServers": [
      {
        "urls": [
          "stun:stun1.l.google.com:19302",
          "stun:stun2.l.google.com:19302",
        ]
      }
    ],
  };

  //-------------------------------------------------------------
  // Constraints
  //-------------------------------------------------------------

  final Map<String, dynamic> offerConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };

  //-------------------------------------------------------------
  // Initialize
  //-------------------------------------------------------------

  Future<void> initialize() async {
    if (_initialized) return;

    await localRenderer.initialize();

    await remoteRenderer.initialize();

    _initialized = true;
  }

  //-------------------------------------------------------------
  // Local Camera + Mic
  //-------------------------------------------------------------

  Future<void> createLocalStream({
    bool video = true,
  }) async {
    final mediaConstraints = {
      "audio": true,
      "video": video
          ? {
              "facingMode": "user",
              "width": 1280,
              "height": 720,
              "frameRate": 30,
            }
          : false,
    };

    localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

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
    // Remote Stream
    //---------------------------------------------------------

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteStream = event.streams.first;

        remoteRenderer.srcObject = remoteStream;
      }
    };

    //---------------------------------------------------------
    // Connection State
    //---------------------------------------------------------

    _peerConnection!.onConnectionState =
        (RTCPeerConnectionState state) {
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
    // ICE Gathering
    //---------------------------------------------------------

    _peerConnection!.onIceGatheringState =
        (RTCIceGatheringState state) {};

    //---------------------------------------------------------
    // Signaling
    //---------------------------------------------------------

    _peerConnection!.onSignalingState =
        (RTCSignalingState state) {};

    //---------------------------------------------------------
    // ICE Connection
    //---------------------------------------------------------

    _peerConnection!.onIceConnectionState =
        (RTCIceConnectionState state) {};

    //---------------------------------------------------------
    // Remove Stream
    //---------------------------------------------------------

    // _peerConnection!.onRemoveStream = (stream) {
    //   remoteRenderer.srcObject = null;
    // };
  }

  //-------------------------------------------------------------
  // Mic
  //-------------------------------------------------------------

  Future<void> toggleMic(bool enabled) async {
    if (localStream == null) return;

    for (final track in localStream!.getAudioTracks()) {
      track.enabled = enabled;
    }
  }

  //-------------------------------------------------------------
  // Camera
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

    final track = localStream!.getVideoTracks().first;

    await Helper.switchCamera(track);
  }
    //-------------------------------------------------------------
  // Create Call (Caller)
  //-------------------------------------------------------------

  Future<void> createCall({
    required String callId,
    required bool isVideoCall,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    await createLocalStream(video: isVideoCall);

    await _createPeerConnection();

    _callDoc = _firestore.collection("calls").doc(callId);

    //---------------------------------------------------------
    // Caller ICE
    //---------------------------------------------------------

    _peerConnection!.onIceCandidate = (candidate) async {
      if (candidate.candidate == null) return;

      await _callDoc!
          .collection("callerCandidates")
          .add(candidate.toMap());
    };

    //---------------------------------------------------------
    // Create Offer
    //---------------------------------------------------------

    RTCSessionDescription offer =
        await _peerConnection!.createOffer(offerConstraints);

    await _peerConnection!.setLocalDescription(offer);

    await _callDoc!.set({
      "offer": offer.toMap(),
      "type": isVideoCall ? "video" : "audio",
      "status": "ringing",
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    //---------------------------------------------------------
    // Listen Answer
    //---------------------------------------------------------

    _callSubscription = _callDoc!.snapshots().listen((snapshot) async {
      if (!snapshot.exists) return;

      final data = snapshot.data();

      if (data == null) return;

      if (data["answer"] != null &&
           !_remoteDescriptionSet) {
        final answer = RTCSessionDescription(
          data["answer"]["sdp"],
          data["answer"]["type"],
        );

        await _peerConnection!.setRemoteDescription(answer);
        _remoteDescriptionSet = true;
      }
    });

    //---------------------------------------------------------
    // Listen Receiver ICE
    //---------------------------------------------------------

    _receiverCandidatesSubscription = _callDoc!
        .collection("receiverCandidates")
        .snapshots()
        .listen((snapshot) async {
      for (final change in snapshot.docChanges) {
        if (change.type != DocumentChangeType.added) continue;

        final data = change.doc.data();

        if (data == null) continue;

        await _peerConnection!.addCandidate(
          RTCIceCandidate(
            data["candidate"],
            data["sdpMid"],
            data["sdpMLineIndex"],
          ),
        );
      }
    });
  }

  //-------------------------------------------------------------
  // Join Call (Receiver)
  //-------------------------------------------------------------

  Future<void> joinCall({
    required String callId,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    _callDoc = _firestore.collection("calls").doc(callId);

    final snapshot = await _callDoc!.get();

    if (!snapshot.exists) {
      throw Exception("Call not found.");
    }

    final data = snapshot.data()!;

    final bool isVideo =
        data["type"] == "video";

    await createLocalStream(video: isVideo);

    await _createPeerConnection();

    //---------------------------------------------------------
    // Receiver ICE
    //---------------------------------------------------------

    _peerConnection!.onIceCandidate = (candidate) async {
      if (candidate.candidate == null) return;

      await _callDoc!
          .collection("receiverCandidates")
          .add(candidate.toMap());
    };

    //---------------------------------------------------------
    // Remote Offer
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

    RTCSessionDescription answer =
        await _peerConnection!.createAnswer();

    await _peerConnection!.setLocalDescription(answer);

    await _callDoc!.update({
      "answer": answer.toMap(),
      "status": "connected",
    });

    //---------------------------------------------------------
    // Listen Caller ICE
    //---------------------------------------------------------

    _callerCandidatesSubscription = _callDoc!
        .collection("callerCandidates")
        .snapshots()
        .listen((snapshot) async {
      for (final change in snapshot.docChanges) {
        if (change.type != DocumentChangeType.added) continue;

        final data = change.doc.data();

        if (data == null) continue;

        await _peerConnection!.addCandidate(
          RTCIceCandidate(
            data["candidate"],
            data["sdpMid"],
            data["sdpMLineIndex"],
          ),
        );
      }
    });
  }

    //-------------------------------------------------------------
  // Hang Up
  //-------------------------------------------------------------

  Future<void> hangUp(String callId) async {
    try {
      final callDoc = _firestore.collection("calls").doc(callId);

      //---------------------------------------------------------
      // Delete caller candidates
      //---------------------------------------------------------

      final callerCandidates =
          await callDoc.collection("callerCandidates").get();

      for (final doc in callerCandidates.docs) {
        await doc.reference.delete();
      }

      //---------------------------------------------------------
      // Delete receiver candidates
      //---------------------------------------------------------

      final receiverCandidates =
          await callDoc.collection("receiverCandidates").get();

      for (final doc in receiverCandidates.docs) {
        await doc.reference.delete();
      }

      //---------------------------------------------------------
      // Delete call document
      //---------------------------------------------------------

      await callDoc.delete();
    } catch (_) {}

    await dispose();
  }

  //-------------------------------------------------------------
  // Dispose Everything
  //-------------------------------------------------------------

  Future<void> dispose() async {
    _remoteDescriptionSet = false;
    //---------------------------------------------------------
    // Cancel Firestore listeners
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
  // Release Renderers
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

    return localStream!.getAudioTracks().isNotEmpty &&
        localStream!.getAudioTracks().first.enabled;
  }

  bool get isCameraEnabled {
    if (localStream == null) return false;

    return localStream!.getVideoTracks().isNotEmpty &&
        localStream!.getVideoTracks().first.enabled;
  }

  bool get hasRemoteVideo {
    return remoteRenderer.srcObject != null;
  }

  bool get hasLocalVideo {
    return localRenderer.srcObject != null;
  }
}