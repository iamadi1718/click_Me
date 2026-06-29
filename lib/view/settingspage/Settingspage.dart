import 'package:click_me/view/blockedaccounts/Manageblocked.dart';
import 'package:click_me/view/changepasswordpage/ChangePasswordPage.dart';
import 'package:click_me/view/privacypage/PrivacyPage.dart';

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = false;

  Widget settingTile({
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color textColor = Colors.black,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            settingTile(
              title: 'Manage blocked accounts',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Manageblocked()),
                );
              },
            ),
            settingTile(
              title: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
            ),
            settingTile(
              title: 'App Theme',
              trailing: Switch(
                value: isDark,
                onChanged: (value) {
                  setState(() {
                    isDark = value;
                  });
                },
              ),
            ),
            settingTile(
              title: 'Privacy Preferences',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Help Center',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ),
            settingTile(
              title: 'Log out',
              textColor: Colors.red,
              trailing: const Icon(Icons.logout, color: Colors.red),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
