import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallScreen extends StatefulWidget {
  final String chatName;
  final String callId;
  final String callType;

  const CallScreen({super.key, required this.chatName, required this.callId, required this.callType});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              height: 56,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.chatName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text("Call Type: ${widget.callType}"),
    Text("Call ID: ${widget.callId}"),
                ],
              ),
            ),

            // Video Split View
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                child: Column(
                  children: [
                    // Upper Half (Remote Video - Cat with sunglasses)
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Center Profile Avatar
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xff550D9B), // Purple border matching the screenshot
                                  width: 2.0,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Horizontal divider line
                    Container(
                      height: 2,
                      color: Colors.white,
                    ),

                    // Lower Half (Local Video - Wave/Woman)
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: _isVideoOff
                                ? Container(
                                    color: const Color(0xFF1E1E2C),
                                    child: Center(
                                      child: Icon(
                                        Icons.videocam_off,
                                        color: Colors.white.withValues(alpha: 0.3),
                                        size: 48,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    "assets/images/live.jpg",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          // Center Profile Avatar
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xff550D9B),
                                  width: 2.0,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/images/live.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          // Control Buttons Overlay at the bottom
                          Positioned(
                            bottom: 24.0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Video Toggle Button
                                IconButton(
                                  icon: Icon(
                                    _isVideoOff
                                        ? Icons.videocam_off_rounded
                                        : Icons.videocam_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isVideoOff = !_isVideoOff;
                                    });
                                  },
                                ),

                                // End Call Button
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.call_end_rounded,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),

                                // Mute Toggle Button
                                IconButton(
                                  icon: Icon(
                                    _isMuted
                                        ? Icons.mic_off_rounded
                                        : Icons.mic_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isMuted = !_isMuted;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}