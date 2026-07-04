import 'package:click_me/services/CallServices/CallServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/view/utils/Api.dart';

class OutgoingCallScreen extends StatelessWidget {
  final String callId;
  final String callType;
  final String userName;
  final String? profileImage;

  const OutgoingCallScreen({
    super.key,
    required this.callId,
    required this.callType,
    required this.userName,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
              const SizedBox(height: 40),
          
              CircleAvatar(
                radius: 45,
                backgroundImage:
    profileImage != null &&
            profileImage!.isNotEmpty
        ? NetworkImage(
            "${Api.baseUrl}$profileImage",
          )
        : const AssetImage(
            "assets/images/profile.jpg",
          ) as ImageProvider,
              ),
          
              const SizedBox(height: 15),
          
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
          
              const SizedBox(height: 8),
          
              Text(
                "Waiting for answer...",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 18,
                ),
              ),
          
              const SizedBox(height: 5),
          
              const CircularProgressIndicator(),
          
              const Spacer(),
          
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () async {
          
                  await CallService().endCall(
                    callId: callId,
                  );
          
                  Get.back();
                },
                child: const Icon(Icons.call_end),
              ),
          
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}