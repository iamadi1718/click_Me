import 'package:flutter/material.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),

        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),

        children: [
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

class NotificationItem extends StatelessWidget {
  final String image;
  final String username;
  final String others;
  final String action;
  final String time;

  const NotificationItem({
    super.key,
    required this.image,
    required this.username,
    required this.others,
    required this.action,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(radius: 22, backgroundImage: AssetImage(image)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Inter',
                ),
                children: [
                  TextSpan(
                    text: username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (others.isNotEmpty) ...[
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "$others others",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                  TextSpan(text: " $action"),
                  TextSpan(
                    text: "  $time",
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
