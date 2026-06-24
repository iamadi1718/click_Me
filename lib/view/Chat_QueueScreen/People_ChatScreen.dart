import 'package:flutter/material.dart';
import 'package:click_me/view/custom/Message_Bubble.dart';
import 'package:click_me/view/Call%20Screen/Call_Screen.dart';
import 'package:click_me/view/custom/Chat_message.dart';
import 'package:click_me/view/custom/chat_background.dart';
import 'package:click_me/view/custom/wallpaper.dart';

class PeopleChatScreen extends StatefulWidget {
  final String chatName;

  const PeopleChatScreen({super.key, required this.chatName});

  @override
  State<PeopleChatScreen> createState() => _PeopleChatScreenState();
}

class _PeopleChatScreenState extends State<PeopleChatScreen> {
  final TextEditingController messageController = TextEditingController();

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
                    Navigator.pop(context);
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          chatName: widget.chatName,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.call_outlined, size: 32),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          chatName: widget.chatName,
                        ),
                      ),
                    );
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
              child: ListView(
                reverse: true,
                padding: const EdgeInsets.all(16),
                children: const [
                  MessageBubble(message: "Received message here", isMe: true),

                  MessageBubble(message: "How are you?", isMe: true),

                  MessageBubble(message: "I am fine", isMe: false),

                  MessageBubble(message: "Sent message here", isMe: false),
                ],
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


