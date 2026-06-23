import 'package:flutter/material.dart';
import 'package:click_me/Chat_QueueScreen/Chat_List.dart';
import 'package:click_me/Chat_QueueScreen/group_list.dart';

class ChatQueue extends StatefulWidget {
  const ChatQueue({super.key});

  @override
  State<ChatQueue> createState() => _ChatQueueState();
}

class _ChatQueueState extends State<ChatQueue> {
  int _selectedTab = 0; // 0 for People, 1 for Groups

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: const Text(
          "Chat Queue",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search chat here",
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: Icon(Icons.search, color: Colors.grey[600], size: 32),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                filled: true,
                fillColor: const Color(
                  0xFFE0E0E0,
                ), // Matches the light grey background in the image
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 20.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Selection Row: [People] [Groups] ... [Requests]
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                // People Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _selectedTab == 0
                              ? const Color(0xFF8685EF) // Active purple
                              : const Color(0xFFE0E0E0), // Inactive grey
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "People",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Groups Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _selectedTab == 1
                              ? const Color(0xFF8685EF)
                              : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Groups",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Requests Text Link
                TextButton(
                  onPressed: () {
                    // Action for Requests
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(60, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Requests",
                    style: TextStyle(
                      color: Color(0xFF7372E2),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Content body based on selection
          Expanded(child: _selectedTab == 0 ? ChatList() : const GroupList()),
        ],
      ),
    );
  }
}
