import 'package:flutter/material.dart';
import 'package:click_me/Chat_QueueScreen/Group_ChatScreen.dart';

class GroupItem {
  final String name;
  final String lastMessage;
  final String lastSender;
  final String time;
  final int unreadCount;
  final List<String> avatarUrls;

  const GroupItem({
    required this.name,
    required this.lastMessage,
    required this.lastSender,
    required this.time,
    required this.unreadCount,
    required this.avatarUrls,
  });
}

class GroupList extends StatelessWidget {
  const GroupList({super.key});

  static List<GroupItem> getDummyGroups() {
    return const [
      GroupItem(
        name: "GroupName1",
        lastSender: "Alex",
        lastMessage: "Let's push the new build today.",
        time: "10m",
        unreadCount: 3,
        avatarUrls: [
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80",
          "https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=100&q=80",
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=100&q=80",
        ],
      ),
      GroupItem(
        name: "GroupName2",
        lastSender: "Zara",
        lastMessage: "I uploaded the final mockups.",
        time: "1h",
        unreadCount: 1,
        avatarUrls: [
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=100&q=80",
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80",
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=80",
        ],
      ),
      GroupItem(
        name: "GroupName3",
        lastSender: "Marcus",
        lastMessage: "The campaign starts next Monday.",
        time: "4h",
        unreadCount: 0,
        avatarUrls: [
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80",
          "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=100&q=80",
          "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=100&q=80",
        ],
      ),
      GroupItem(
        name: "GroupName4",
        lastSender: "Sarah",
        lastMessage: "Meeting is postponed to 3 PM.",
        time: "Yesterday",
        unreadCount: 0,
        avatarUrls: [
          "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=100&q=80",
          "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=100&q=80",
          "https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=100&q=80",
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dummyGroups = getDummyGroups();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      itemCount: dummyGroups.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final group = dummyGroups[index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupChatScreen(groupName: group.name),
              ),
            );
          },
          child: Row(
            children: [
              // Stacked Group Avatar (matches user layout using dynamic network images)
              SizedBox(
                width: 100,
                height: 60,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 20,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(group.avatarUrls[0]),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 25,
                      top: 0,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(group.avatarUrls[1]),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      top: 15,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(group.avatarUrls[2]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Name and Last Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${group.lastSender}: ${group.lastMessage}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight:
                            group.unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color:
                            group.unreadCount > 0
                                ? Colors.black
                                : Colors.grey[600],
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
                    group.time,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (group.unreadCount > 0)
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
        );
      },
    );
  }
}
