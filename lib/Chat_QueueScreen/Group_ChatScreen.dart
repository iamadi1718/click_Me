import 'package:flutter/material.dart';
import 'package:click_me/custom/Message_Bubble.dart';
import 'package:click_me/custom/Chat_message.dart';
import 'package:click_me/custom/chat_background.dart';
import 'package:click_me/custom/wallpaper.dart';

class GroupChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String groupName;

  const GroupChatAppBar({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          ),
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage("assets/images/group.jpg"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  groupName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  "3 members",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
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
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class GroupChatScreen extends StatefulWidget {
  final String groupName;

  const GroupChatScreen({super.key, required this.groupName});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GroupChatAppBar(groupName: widget.groupName),
      body: ChatBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                padding: const EdgeInsets.all(16),
                children: const [
                  MessageBubble(message: "Sent message here", isMe: true),
                  MessageBubble(
                    message: "Received message here",
                    isMe: false,
                    senderName: "user2:",
                  ),
                  MessageBubble(
                    message: "Received message here",
                    isMe: false,
                    senderName: "user1:",
                  ),
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
