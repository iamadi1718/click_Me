import 'dart:async';

import 'package:click_me/services/CallServices/CallWebRTCSignaling.dart';
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

  final signaling = WebRTCSignaling.instance;

  bool micEnabled = true;

  bool speakerEnabled = false;

  bool cameraEnabled = true;

  bool callConnected = false;

  Duration duration = Duration.zero;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    initializeCall();
  }
    void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        setState(() {
          duration += const Duration(seconds: 1);
        });
      },
    );
  }
  Widget buildRemoteVideo() {
  if (!widget.isVideoCall) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Center(
        child: CircleAvatar(
          radius: 60,
          backgroundImage: widget.profileImage != null &&
                  widget.profileImage!.isNotEmpty
              ? NetworkImage(widget.profileImage!)
              : null,
          child: widget.profileImage == null
              ? const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }

  return Positioned.fill(
    child: RTCVideoView(
      signaling.remoteRenderer,
      objectFit:
          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    ),
  );
}
Widget buildLocalPreview() {
  return Positioned(
    right: 15,
    top: 80,
    child: Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black54,
      ),
      clipBehavior: Clip.hardEdge,
      child: cameraEnabled
          ? RTCVideoView(
              signaling.localRenderer,
              mirror: true,
              objectFit:
                  RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            )
          : const Center(
              child: Icon(
                Icons.videocam_off,
                color: Colors.white,
                size: 40,
              ),
            ),
    ),
  );
}
Widget buildTopBar() {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [

          Text(
            widget.chatName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            callConnected
                ? formattedTime
                : widget.isCaller
                    ? "Calling..."
                    : "Connecting...",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget controlButton({
  required IconData icon,
  required VoidCallback onTap,
  Color background = const Color(0xff2B2B2B),
}) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: 30,
      backgroundColor: background,
      child: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
    ),
  );
}
Widget buildBottomControls() {
  return Container(
    padding: const EdgeInsets.only(
      left: 20,
      right: 20,
      top: 15,
      bottom: 30,
    ),
    color: Colors.black,
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

            setState(() {});
          },
        ),

        //-------------------------------------------------
        // Speaker
        //-------------------------------------------------

        controlButton(
          icon: speakerEnabled
              ? Icons.volume_up
              : Icons.hearing,
          onTap: () async {
            speakerEnabled = !speakerEnabled;

            await signaling.setSpeaker(speakerEnabled);

            setState(() {});
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
            icon: cameraEnabled
                ? Icons.videocam
                : Icons.videocam_off,
            onTap: () async {
              cameraEnabled = !cameraEnabled;

              await signaling.toggleCamera(cameraEnabled);

              setState(() {});
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

  String get formattedTime {

    final h = duration.inHours;

    final m =
        (duration.inMinutes % 60).toString().padLeft(2, '0');

    final s =
        (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (h > 0) {
      return "${h.toString().padLeft(2, '0')}:$m:$s";
    }

    return "$m:$s";
  }
    Future<void> initializeCall() async {

    signaling.onConnected = () {

      if (!mounted) return;

      setState(() {
        callConnected = true;
      });

      startTimer();
    };

    signaling.onDisconnected = () {

      if (!mounted) return;

      Get.back();
    };

    if (widget.isCaller) {

      await signaling.createCall(
        callId: widget.callId,
        isVideoCall: widget.isVideoCall,
      );

    } else {

      await signaling.joinCall(
        callId: widget.callId,
      );

    }

    if (mounted) {
      setState(() {});
    }
  }
    Future<void> endCall() async {

    timer?.cancel();

    await signaling.hangUp(widget.callId);

    if (mounted) {
      Get.back();
    }
  }
    @override
  void dispose() {

    timer?.cancel();

    // signaling.release();

    super.dispose();
  }
    @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: SafeArea(

        child: Column(

          children: [

            Expanded(

              child: Stack(

                children: [

                  buildRemoteVideo(),

                  if (widget.isVideoCall)
                    buildLocalPreview(),

                  buildTopBar(),

                ],
              ),

            ),

            buildBottomControls(),

          ],

        ),

      ),

    );

  }

}