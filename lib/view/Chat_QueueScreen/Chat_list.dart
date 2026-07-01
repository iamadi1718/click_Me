import 'package:click_me/Models/ChatThreadModel/ChatThreadModel.dart';
import 'package:click_me/services/Chatservices/Chatservices.dart';
import 'package:click_me/view/Chat_QueueScreen/People_ChatScreen.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:click_me/view/utils/Time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Future<ChatThreadModel>? futureChat;

  @override
  void initState() {
    super.initState();
    futureChat = ChatService().getChatData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatThreadModel>(
      future: futureChat,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData ||
            snapshot.data!.data == null ||
            snapshot.data!.data!.threads == null) {
          return const Center(child: Text("No Chats"));
        }

        final threads = snapshot.data!.data!.threads!;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: threads.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final thread = threads[index];

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                print("Thread ID: ${thread.id}");
               Get.to(() => PeopleChatScreen(
                 chatName:
                     "${thread.participant?.firstName ?? ""} ${thread.participant?.lastName ?? ""}",
                 threadId: thread.id!,
                  receiverId: thread.participant!.id!,
               )); },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          thread.participant?.profileImage != null
                              ? NetworkImage(
                                "${Api.baseUrl}${thread.participant!.profileImage}",
                              )
                              : null,
                      child:
                          thread.participant?.profileImage == null
                              ? const Icon(Icons.person)
                              : null,
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${thread.participant?.firstName ?? ""} ${thread.participant?.lastName ?? ""}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            thread.lastMessage?.text ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  thread.unreadCount! > 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  thread.unreadCount! > 0
                                      ? Colors.black
                                      : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          getTimeAgo(thread.lastMessageAt ?? ""),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 8),

                        if (thread.unreadCount! > 0)
                          CircleAvatar(
                            radius: 9,
                            backgroundColor: const Color(0xff7372E2),
                            child: Text(
                              thread.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

