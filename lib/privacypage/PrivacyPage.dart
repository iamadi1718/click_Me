import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Preferences'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Private Account',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Switch(
                  value: isPrivate,
                  onChanged: (value) {
                    setState(() {
                      isPrivate = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'When your account is public, anyone can see and interact with your posts regardless of being your follower.\n\n'
              'Having a private account gives who the control over who can interact with your posts. When your account is private, only the followers that you approve can see what you share, including your photos, videos on hashtags and location logs.\n\n'
              'Certain information, such as your profile picture, user name, name, follower count, and following count, is visible to everyone whether they have an account here or not.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}