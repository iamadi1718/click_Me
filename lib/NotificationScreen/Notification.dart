import 'package:flutter/material.dart';
import 'package:click_me/NotificationScreen/Notification_Detail_Screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
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
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),

            const Text(
              "Notifications",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.group, color: Colors.black),
            ),
            title: const Text(
              "Follow Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              "219 users",
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            trailing: const Text(
              "30m",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "Other Activities",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: const Divider()),
            ],
          ),
          const SizedBox(height: 15),
          ...List.generate(
            5,
            (index) => const NotificationItem(
              image: "assets/images/chill.jpg",
              username: "xyzname.ab",
              others: "110",
              action: "liked your story.",
              time: "12m",
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Text(
                "Yesterday",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: const Divider()),
            ],
          ),
          const SizedBox(height: 15),
          ...List.generate(
            5,
            (index) => const NotificationItem(
              image: "assets/images/chill.jpg",
              username: "xyzname.ab",
              others: "110",
              action: "liked your story.",
              time: "48h",
            ),
          ),
        ],
      ),
    );
  }
}
