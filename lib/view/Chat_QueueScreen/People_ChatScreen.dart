import 'dart:async';

import 'package:click_me/Models/ChatMessagesModel/ChatMessageModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/services/CallServices/CallServices.dart';
import 'package:click_me/services/ChatDetailsServices/ChatDetailsServices.dart';
import 'package:click_me/services/SendMessageService/SendMessageService.dart';
import 'package:click_me/services/socket_manager.dart';
import 'package:click_me/services/SocketManager.dart';

import 'package:click_me/view/Chat_QueueScreen/OutgoingCallScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/view/custom/Message_Bubble.dart';
import 'package:click_me/view/custom/Chat_message.dart';
import 'package:click_me/view/custom/chat_background.dart';
import 'package:click_me/view/custom/wallpaper.dart';

class PeopleChatScreen extends StatefulWidget {
  final String chatName;
  final String threadId;
  final String receiverId;

  const PeopleChatScreen({
    super.key,
    required this.chatName,
    required this.threadId,
    required this.receiverId,
  });

  @override
  State<PeopleChatScreen> createState() => _PeopleChatScreenState();
}

class _PeopleChatScreenState extends State<PeopleChatScreen> {
  final currentUserId = StorageService.getUserId();
  List<Message> messages = [];
  bool isLoading = true;
  final TextEditingController messageController = TextEditingController();
  Future<void> loadMessages() async {
    try {
      final response = await ChatMessageService().getMessages(widget.threadId);

      if (!mounted) return;

      final newMessages = response.data?.messages ?? [];

      // Only update if the message count changed
      if (newMessages.length != messages.length) {
        setState(() {
          messages = newMessages;
        });
      }

      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Timer? _timer;
  StreamSubscription? _messageSub;

  @override
  void initState() {
    super.initState();
    SocketManager.instance.currentChatThreadId = widget.threadId;

    loadMessages();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) => loadMessages());

    _messageSub = SocketManager.instance.onReceiveMessage.listen((data) {
      if (mounted) {
        setState(() {
          messages.insert(0, Message.fromJson(data));
        });
      }
    });
  }

  @override
  void dispose() {
    SocketManager.instance.currentChatThreadId = null;
    _messageSub?.cancel();
    _timer?.cancel();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),

        child: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),

            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back, size: 32),
                ),

                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage("assets/images/profile.jpg"),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Text(
                        "username",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const WallpaperDialog(),
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: ValueListenableBuilder<WallpaperModel>(
                    valueListenable: WallpaperManager.currentWallpaper,
                    builder: (context, wallpaper, _) {
                      return CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            wallpaper.imageAsset != null
                                ? AssetImage(wallpaper.imageAsset!)
                                : null,
                        backgroundColor:
                            wallpaper.gradient != null
                                ? wallpaper.gradient!.colors[0]
                                : Colors.deepPurple,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: () async {
                    print("========== BEFORE REQUEST ==========");
                    print("Socket Object : ${SocketManager().socket}");
                    print(
                      "Socket Connected : ${SocketManager().socket?.connected}",
                    );
                    print("isConnected : ${SocketManager().isConnected.value}");
                    print("===================================");
                    try {
                      final response = await CallService().requestCall(
                        receiverId: widget.receiverId,
                        callType: "audio",
                      );

                      if (response.success == true) {
                        final receiver = response.data?.receiver;
                        print("================================");
                        print("Before opening Outgoing Screen");
                        print("Socket object : ${SocketManager().socket}");
                        print(
                          "Connected : ${SocketManager().socket?.connected}",
                        );
                        print("================================");
                        Get.to(
                          () => OutgoingCallScreen(
                            userName:
                                receiver?.fullName.isNotEmpty == true
                                    ? receiver!.fullName
                                    : widget.chatName,
                            profileImage: receiver?.profilePicture,
                            callId: response.data?.callId ?? "",
                            callType: response.data?.callType ?? "audio",
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: const Icon(Icons.call_outlined, size: 32),
                ),

                IconButton(
                  onPressed: () async {
                    print("========== BEFORE REQUEST ==========");
                    print("Socket Object : ${SocketManager().socket}");
                    print(
                      "Socket Connected : ${SocketManager().socket?.connected}",
                    );
                    print("isConnected : ${SocketManager().isConnected.value}");
                    print("===================================");
                    try {
                      final response = await CallService().requestCall(
                        receiverId: widget.receiverId,
                        callType: "video",
                      );

                      if (response.success == true) {
                        final receiver = response.data?.receiver;
                        print("================================");
                        print("Before opening Outgoing Screen");
                        print("Socket object : ${SocketManager().socket}");
                        print(
                          "Connected : ${SocketManager().socket?.connected}",
                        );
                        print("================================");
                        Get.to(
                          () => OutgoingCallScreen(
                            userName:
                                receiver?.fullName.isNotEmpty == true
                                    ? receiver!.fullName
                                    : widget.chatName,
                            profileImage: receiver?.profilePicture,
                            callId: response.data?.callId ?? "",
                            callType: response.data?.callType ?? "audio",
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: const Icon(Icons.videocam_outlined, size: 32),
                ),
              ],
            ),
          ),
        ),
      ),

      body: ChatBackground(
        child: Column(
          children: [
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - 1 - index];

                          return MessageBubble(
                            message: message.text ?? "",
                            isMe: message.senderId?.id == currentUserId,
                          );
                        },
                      ),
            ),
            ChatInputField(
              controller: messageController,
              onSend: () async {
                if (messageController.text.trim().isEmpty) return;

                try {
                  final response = await SendMessageService().sendMessage(
                    threadId: widget.threadId,
                    receiverId: widget.receiverId,
                    message: messageController.text.trim(),
                  );

                  if (response.success == true) {
                    messageController.clear();

                    await loadMessages();
                  }
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
