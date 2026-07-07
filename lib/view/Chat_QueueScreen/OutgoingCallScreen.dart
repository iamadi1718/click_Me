import 'package:click_me/services/CallServices/CallServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/view/utils/Api.dart';
import 'dart:async';
import 'package:click_me/services/SocketManager.dart';
import 'package:click_me/view/Call Screen/Call_Screen.dart';

class OutgoingCallScreen extends StatefulWidget {
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
  State<OutgoingCallScreen> createState() => _OutgoingCallScreenState();
}

class _OutgoingCallScreenState extends State<OutgoingCallScreen> {
  late StreamSubscription callAcceptedSubscription;
  late Timer socketDebugTimer;
  @override
  
  @override
void initState() {
  super.initState();

  print("========== OUTGOING SCREEN ==========");
  print("Waiting for callAccepted...");
  print("Socket Connected : ${SocketManager().socket?.connected}");
  print("CallId : ${widget.callId}");
  print("====================================");

  socketDebugTimer = Timer.periodic(
    const Duration(seconds: 1),
    (timer) {
      print("========== SOCKET STATUS ==========");
      print("Socket Object : ${SocketManager().socket}");
      print("Socket Connected : ${SocketManager().socket?.connected}");
      print("Socket Id : ${SocketManager().socket?.id}");
      print("===================================");
    },
  );

  callAcceptedSubscription =
      SocketManager().onCallAccepted.listen((data) {
print("WAITING SCREEN RECEIVED");
  print(data);

    Get.off(
      () => CallScreen(
        callId: widget.callId,
        chatName: widget.userName,
        profileImage: widget.profileImage,
        isCaller: true,
        isVideoCall: widget.callType == "video",
      ),
    );
  });
}
 @override
void dispose() {
  socketDebugTimer.cancel();
  callAcceptedSubscription.cancel();
  super.dispose();
}

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
                    widget.profileImage != null &&
                            widget.profileImage!.isNotEmpty
                        ? NetworkImage("${Api.baseUrl}${widget.profileImage}")
                        : const AssetImage("assets/images/profile.jpg")
                            as ImageProvider,
              ),

              const SizedBox(height: 15),

              Text(
                widget.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Waiting for answer...",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
              ),

              const SizedBox(height: 5),

              const CircularProgressIndicator(),

              const Spacer(),

              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () async {
                  await CallService().endCall(callId: widget.callId);

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
