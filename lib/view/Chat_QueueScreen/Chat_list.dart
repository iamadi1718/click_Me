import 'package:click_me/view/Chat_QueueScreen/People_ChatScreen.dart';
import 'package:flutter/material.dart';

class ChatItem {
  final String name;
  final String message;
  final String unreadText;
  final String time;
  final bool isUnread;
  final String avatarUrl;

  const ChatItem({
    required this.name,
    required this.message,
    required this.unreadText,
    required this.time,
    required this.isUnread,
    required this.avatarUrl,
  });
}

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  static List<ChatItem> getDummyChats() {
    return const [
      ChatItem(
        name: "Chat name 1",
        message: "",
        unreadText: "4+ new messages",
        time: "3m",
        isUnread: true,
        avatarUrl:
            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80",
      ),
      ChatItem(
        name: "Chat name 2",
        message: "",
        unreadText: "2 new messages",
        time: "10m",
        isUnread: true,
        avatarUrl:
            "https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=150&q=80",
      ),
      ChatItem(
        name: "Chat name 3",
        message: "",
        unreadText: "3 new messages",
        time: "29m",
        isUnread: true,
        avatarUrl:
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80",
      ),
      ChatItem(
        name: "Chat name 4",
        message: "",
        unreadText: "1 new message",
        time: "37m",
        isUnread: true,
        avatarUrl:
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80",
      ),
      ChatItem(
        name: "Chat name 5",
        message: "for that matter I was just...",
        unreadText: "",
        time: "1h",
        isUnread: false,
        avatarUrl:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80",
      ),
      ChatItem(
        name: "Chat name 6",
        message: "for example, it's just new...",
        unreadText: "",
        time: "1h",
        isUnread: false,
        avatarUrl:
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dummyChats = getDummyChats();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      itemCount: dummyChats.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final chat = dummyChats[index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PeopleChatScreen(chatName: chat.name),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
              children: [
                // Circular Profile Picture
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(chat.avatarUrl),
                ),
                const SizedBox(width: 16),
                // Name and Message/Unread Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w600, // Medium-bold font weight
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat.isUnread ? chat.unreadText : chat.message,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight:
                              chat.isUnread
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color:
                              chat.isUnread ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Time and Purple Dot indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat.time,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (chat.isUnread)
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7372E2), // Matching purple dot color
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      const SizedBox(height: 12, width: 12),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
