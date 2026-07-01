import 'package:click_me/Models/ChatMessagesModel/ChatMessageModel.dart';
import 'package:click_me/services/CallServices/CallServices.dart';
import 'package:click_me/services/ChatDetailsServices/ChatDetailsServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/view/custom/Message_Bubble.dart';
import 'package:click_me/view/Call%20Screen/Call_Screen.dart';
import 'package:click_me/view/custom/Chat_message.dart';
import 'package:click_me/view/custom/chat_background.dart';
import 'package:click_me/view/custom/wallpaper.dart';

class PeopleChatScreen extends StatefulWidget {
  final String chatName;
  final String threadId;
  final String receiverId;

  const PeopleChatScreen({super.key, required this.chatName, required this.threadId, required this.receiverId});

  @override
  State<PeopleChatScreen> createState() => _PeopleChatScreenState();
}

class _PeopleChatScreenState extends State<PeopleChatScreen> {
  Future<ChatMessageModel>? futureMessages;
  final TextEditingController messageController = TextEditingController();
  @override
void initState() {
  super.initState();

  futureMessages =
      ChatMessageService().getMessages(widget.threadId);
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
  try {
    final response = await CallService().requestCall(
      receiverId: widget.receiverId,
      callType: "audio",
    );

    if (response.success == true) {
      Get.to(() => CallScreen(
        chatName: widget.chatName,
        callId: response.data!.callId!,
        callType: response.data!.callType!,
      ));
    }
  } catch (e) {
    print(e);
  }
},
                  icon: const Icon(Icons.call_outlined, size: 32),
                ),

                IconButton(
                  onPressed: () async {
  try {
    final response = await CallService().requestCall(
      receiverId: widget.receiverId,
      callType: "video",
    );

    if (response.success == true) {
      Get.to(() => CallScreen(
        chatName: widget.chatName,
        callId: response.data!.callId!,
        callType: response.data!.callType!,
      ));
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
  child: FutureBuilder<ChatMessageModel>(
    future: futureMessages,
    builder: (context, snapshot) {

      if (snapshot.connectionState ==
          ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: Text(snapshot.error.toString()),
        );
      }

      final messages =
          snapshot.data?.data?.messages ?? [];

      return ListView.builder(
        reverse: true,
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {

          final message =
              messages[messages.length - 1 - index];

          return MessageBubble(
            message: message.text ?? "",

       
            isMe: message.senderId?.id ==
                "6a33d1ada6d326341a9c10f4",
          );
        },
      );
    },
  ),
),
 ChatInputField(
              controller: messageController,
              onSend: () {
                print(messageController.text);

                messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}


