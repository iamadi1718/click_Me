import 'dart:async';

import 'package:click_me/services/CallServices/CallServices.dart';
import 'package:click_me/services/CallServices/CallWebRTCSignaling.dart';
import 'package:click_me/services/SocketManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class CallScreen extends StatefulWidget {
  final String callId;
  final String chatName;
  final String? profileImage;
  final bool isCaller;
  final bool isVideoCall;

  const CallScreen({
    super.key,
    required this.callId,
    required this.chatName,
    required this.isCaller,
    required this.isVideoCall,
    this.profileImage,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final WebRTCSignaling signaling = WebRTCSignaling.instance;
  late StreamSubscription callEndedSubscription;

  bool micEnabled = true;
  bool speakerEnabled = false;
  bool cameraEnabled = true;
  bool callConnected = false;

  bool _endingCall = false;

  Duration duration = Duration.zero;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    initializeCall();
    callEndedSubscription =
    SocketManager().onCallEnded.listen((data) {

  print("REMOTE ENDED CALL");
  print(data);

  if (data["callId"] == widget.callId) {
    endCallFromRemote();
  }
});
  }

  //---------------------------------------------------------
  // Timer
  //---------------------------------------------------------

  void startTimer() {
    timer?.cancel();

    duration = Duration.zero;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        duration += const Duration(seconds: 1);
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  //---------------------------------------------------------
  // Initialize Call
  //---------------------------------------------------------
  Future<void> endCallFromRemote() async {

  if (_endingCall) return;

  _endingCall = true;

  stopTimer();

  try {
    await signaling.dispose();
  } catch (_) {}

  if (mounted) {
    Get.back();
  }
}
  Future<void> initializeCall() async {
    signaling.onConnected = () {
      if (!mounted) return;

      if (!callConnected) {
        setState(() {
          callConnected = true;
        });

        startTimer();
      }
    };

    signaling.onDisconnected = () async {
      if (!mounted) return;

      stopTimer();

      if (_endingCall) return;

      _endingCall = true;

      if (Navigator.of(context).canPop()) {
        Get.back();
      }
    };

    signaling.onError = (message) {
      if (!mounted) return;

      stopTimer();

      if (_endingCall) return;

      _endingCall = true;

      Get.snackbar(
        "Call Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      if (Navigator.of(context).canPop()) {
        Get.back();
      }
    };

    try {
      if (widget.isCaller) {
        await signaling.createCall(
          callId: widget.callId,
          isVideoCall: widget.isVideoCall,
        );
      } else {
        await signaling.joinCall(callId: widget.callId);
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;

      stopTimer();

      Get.snackbar(
        "Call Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );

      if (Navigator.of(context).canPop()) {
        Get.back();
      }
    }
  }

  //---------------------------------------------------------
  // Call Duration
  //---------------------------------------------------------

  String get formattedTime {
    final hours = duration.inHours;

    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');

    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:$minutes:$seconds";
    }

    return "$minutes:$seconds";
  }

  //---------------------------------------------------------
  // Remote Video
  //---------------------------------------------------------

  Widget buildRemoteVideo() {
    // Audio Call
    if (!widget.isVideoCall) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: CircleAvatar(
          radius: 75,
          backgroundColor: Colors.grey.shade800,
          backgroundImage:
              widget.profileImage != null && widget.profileImage!.isNotEmpty
                  ? NetworkImage(widget.profileImage!)
                  : null,
          child:
              widget.profileImage == null || widget.profileImage!.isEmpty
                  ? const Icon(Icons.person, color: Colors.white, size: 80)
                  : null,
        ),
      );
    }

    // Video Call
    if (signaling.remoteRenderer.srcObject != null) {
      return RTCVideoView(
        signaling.remoteRenderer,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
        mirror: false,
      );
    }

    // Waiting for remote video
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  //---------------------------------------------------------
  // Local Preview
  //---------------------------------------------------------

  Widget buildLocalPreview() {
    return Positioned(
      top: 130,
      right: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 120,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        clipBehavior: Clip.hardEdge,
        child:
            cameraEnabled
                ? RTCVideoView(
                  signaling.localRenderer,
                  // mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
                : const Center(
                  child: Icon(
                    Icons.videocam_off,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
      ),
    );
  }

  //---------------------------------------------------------
  // Top Bar
  //---------------------------------------------------------

  Widget buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          children: [
            Text(
              widget.chatName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 8),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                callConnected
                    ? formattedTime
                    : widget.isCaller
                    ? "Calling..."
                    : "Connecting...",
                key: ValueKey(
                  callConnected
                      ? formattedTime
                      : widget.isCaller
                      ? "calling"
                      : "connecting",
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------
  // Control Button
  //---------------------------------------------------------

  Widget controlButton({
    required IconData icon,
    required VoidCallback onTap,
    Color background = const Color(0xff2B2B2B),
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: background,
        child: Icon(icon, color: Colors.white, size: 25),
      ),
    );
  }

  //---------------------------------------------------------
  // Bottom Controls
  //---------------------------------------------------------

  Widget buildBottomControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //-------------------------------------------------
          // Mic
          //-------------------------------------------------
          controlButton(
            icon: micEnabled ? Icons.mic : Icons.mic_off,
            onTap: () async {
              micEnabled = !micEnabled;

              await signaling.toggleMic(micEnabled);

              if (mounted) {
                setState(() {});
              }
            },
          ),

          //-------------------------------------------------
          // Speaker
          //-------------------------------------------------
          controlButton(
            icon: speakerEnabled ? Icons.volume_up : Icons.hearing,
            onTap: () async {
              speakerEnabled = !speakerEnabled;

              await signaling.setSpeaker(speakerEnabled);

              if (mounted) {
                setState(() {});
              }
            },
          ),

          //-------------------------------------------------
          // End Call
          //-------------------------------------------------
          controlButton(
            icon: Icons.call_end,
            background: Colors.red,
            onTap: () async {
              await endCall();
            },
          ),

          //-------------------------------------------------
          // Camera
          //-------------------------------------------------
          if (widget.isVideoCall)
            controlButton(
              icon: cameraEnabled ? Icons.videocam : Icons.videocam_off,
              onTap: () async {
                cameraEnabled = !cameraEnabled;

                await signaling.toggleCamera(cameraEnabled);

                if (mounted) {
                  setState(() {});
                }
              },
            ),

          //-------------------------------------------------
          // Switch Camera
          //-------------------------------------------------
          if (widget.isVideoCall)
            controlButton(
              icon: Icons.flip_camera_ios,
              onTap: () async {
                await signaling.switchCamera();
              },
            ),
        ],
      ),
    );
  }

  //---------------------------------------------------------
  // End Call
  //---------------------------------------------------------

  Future<void> endCall() async {
  if (_endingCall) return;

  _endingCall = true;

  stopTimer();

  try {
    // Notify backend
    await CallService().endCall(callId: widget.callId);

    // Cleanup WebRTC
    await signaling.hangUp(widget.callId);
  } catch (e) {
    debugPrint("End Call Error: $e");
  }

  if (mounted) {
    Get.back();
  }
}
  //---------------------------------------------------------
  // Dispose
  //---------------------------------------------------------

  @override
  void dispose() {
    stopTimer();

    //---------------------------------------------------------
    // Remove callbacks to avoid calling disposed widget
    //---------------------------------------------------------

    signaling.onConnected = null;
    signaling.onDisconnected = null;
    signaling.onError = null;
    callEndedSubscription.cancel();
    super.dispose();
  }

  //---------------------------------------------------------
  // UI
  //---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await endCall();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildRemoteVideo(),

              /// Local preview
              if (widget.isVideoCall) buildLocalPreview(),

              /// Name + timer
              buildTopBar(),

              /// Bottom controls overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(child: buildBottomControls()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
