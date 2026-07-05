import 'package:click_me/services/CallServices/CallServices.dart';
import 'package:click_me/view/Call Screen/Call_Screen.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncomingCallScreen extends StatelessWidget {
  final String callId;
  final String callType;
  final String callerName;
  final String? profileImage;

  const IncomingCallScreen({
    super.key,
    required this.callId,
    required this.callType,
    required this.callerName,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [

              const SizedBox(height: 40),

              Row(
                children: const [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Incoming Call",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 40),

              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.deepPurple,
                backgroundImage: profileImage != null &&
                        profileImage!.isNotEmpty
                    ? NetworkImage(
                        "${Api.baseUrl}$profileImage",
                      )
                    : null,
                child: profileImage == null ||
                        profileImage!.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 60,
                      )
                    : null,
              ),

              const SizedBox(height: 25),

              Text(
                callerName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                callType == "video"
                    ? "Video Call"
                    : "Voice Call",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  /// DECLINE

                  Column(
                    children: [

                      GestureDetector(
                        onTap: () async {

                          try{

                            await CallService().endCall(
                              callId: callId,
                            );

                            Get.back();

                          }catch(e){

                            Get.snackbar(
                              "Error",
                              e.toString(),
                            );

                          }

                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Decline",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  /// ACCEPT

                  Column(
                    children: [

                      GestureDetector(
                        onTap: () async {

                          try{

                            await CallService().acceptCall(
                              callId: callId,
                            );

                          Get.off(
  () => CallScreen(
    callId: callId,
    chatName: callerName,
    profileImage: profileImage,
    isCaller: false,
    isVideoCall: callType == "video",
  ),
);
}
catch(e){

                            Get.snackbar(
                              "Error",
                              e.toString(),
                            );

                          }

                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Accept",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}