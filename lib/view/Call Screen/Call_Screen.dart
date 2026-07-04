import 'dart:async';

import 'package:click_me/services/CallServices/CallServices.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallScreen extends StatefulWidget {
  final String chatName;
  final String callId;
  final String callType;
  final String? profileImage;
  final bool isCaller;

  const CallScreen({
    super.key,
    required this.chatName,
    required this.callId,
    required this.callType,
    required this.isCaller,
    this.profileImage,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {

  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _speakerOn = false;

  Duration _duration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        setState(() {
          _duration += const Duration(seconds: 1);
        });
      },
    );
  }

  String get timerText {

    final h = _duration.inHours.toString().padLeft(2, '0');
    final m =
        (_duration.inMinutes % 60).toString().padLeft(2, '0');
    final s =
        (_duration.inSeconds % 60).toString().padLeft(2, '0');

    if (_duration.inHours > 0) {
      return "$h:$m:$s";
    }

    return "$m:$s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _endCall() async {

    try {

      await CallService().endCall(
        callId: widget.callId,
      );

      Get.until((route) => route.isFirst);

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: SafeArea(

        child: Column(

          children: [

            ///================ TOP BAR =================

            Container(

              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              child: Row(

                children: [

                  IconButton(

                    onPressed: () {
                      Get.back();
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),

                  ),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(

                          widget.chatName,

                          style: const TextStyle(

                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,

                          ),

                        ),
                                                const SizedBox(height: 5),

                        Text(
                          widget.callType == "video"
                              ? "Video Call"
                              : "Voice Call",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          timerText,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ///================ REMOTE USER =================

            Expanded(
              flex: widget.callType == "video" ? 5 : 8,
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade900,
                child: Stack(
                  children: [

                    /// Remote Video Placeholder
                    Positioned.fill(
                      child: widget.callType == "video"
                          ? Image.asset(
                              "assets/images/live.jpg",
                              fit: BoxFit.cover,
                            )

                          /// Later replace with
                          ///
                          /// RTCVideoView(remoteRenderer)
                          ///
                          : Container(
                              color: Colors.black,
                            ),
                    ),

                    /// Remote Avatar

                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          CircleAvatar(
                            radius: 55,
                            backgroundImage:
                                widget.profileImage != null &&
                                        widget.profileImage!.isNotEmpty
                                    ? NetworkImage(
                                        "${Api.baseUrl}${widget.profileImage}",
                                      )
                                    : const AssetImage(
                                            "assets/images/profile.jpg",
                                          )
                                        as ImageProvider,
                          ),

                          const SizedBox(height: 15),

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
                            widget.isCaller
                                ? "Calling..."
                                : "Connected",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///================ LOCAL VIDEO =================

            if (widget.callType == "video")

              Container(
                height: 180,
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.grey.shade800,
                ),
                child: Stack(
                  children: [

                    Positioned.fill(
                      child: _isVideoOff
                          ? const Center(
                              child: Icon(
                                Icons.videocam_off,
                                color: Colors.white54,
                                size: 50,
                              ),
                            )
                          : Image.asset(
                              "assets/images/live.jpg",
                              fit: BoxFit.cover,
                            ),

                      /// Later replace with
                      ///
                      /// RTCVideoView(localRenderer)
                      ///
                    ),

                    const Positioned(
                      right: 12,
                      top: 12,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
                          ///================== BOTTOM CONTROLS ==================

            Container(
              padding: const EdgeInsets.only(
                bottom: 25,
                top: 10,
              ),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  ///================ MUTE ==================

                  InkWell(
                    onTap: () {
                      setState(() {
                        _isMuted = !_isMuted;

                       
                      });
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade800,
                      child: Icon(
                        _isMuted
                            ? Icons.mic_off
                            : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///================ SPEAKER ==================

                  InkWell(
                    onTap: () {
                      setState(() {
                        _speakerOn = !_speakerOn;

                        /// TODO
                        /// speaker on/off
                      });
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade800,
                      child: Icon(
                        _speakerOn
                            ? Icons.volume_up
                            : Icons.hearing,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///================ END CALL ==================

                  GestureDetector(
                    onTap: _endCall,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),

                  ///================ VIDEO ==================

                  if (widget.callType == "video")
                    InkWell(
                      onTap: () {

                        setState(() {

                          _isVideoOff = !_isVideoOff;

                          /// TODO
                          /// signaling.localStream
                          ///     ?.getVideoTracks()
                          ///     .first
                          ///     .enabled = !_isVideoOff;

                        });

                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade800,
                        child: Icon(
                          _isVideoOff
                              ? Icons.videocam_off
                              : Icons.videocam,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  ///================ SWITCH CAMERA ==================

                  if (widget.callType == "video")
                    InkWell(
                      onTap: () async {

                        /// TODO
                        /// await signaling.switchCamera();

                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade800,
                        child: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}