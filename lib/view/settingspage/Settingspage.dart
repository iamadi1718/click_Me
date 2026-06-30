import 'package:click_me/controller/likecontroller/settings_controller.dart';
import 'package:click_me/view/blockedaccounts/Manageblocked.dart';
import 'package:click_me/view/changepasswordpage/ChangePasswordPage.dart';
import 'package:click_me/view/privacypage/PrivacyPage.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/loginscreen/LoginScreen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final controller = Get.put(SettingsController());

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
                Get.to(() => Manageblocked());
              },
            ),
            settingTile(
              title: 'Change Password',
              onTap: () {
                Get.to(() => ChangePasswordPage());
              },
            ),
            Obx(
              () => settingTile(
                title: 'App Theme',
                trailing: Switch(
                  value: controller.isDark.value,
                  onChanged: controller.toggleTheme,
                ),
              ),
            ),
            settingTile(
              title: 'Privacy Preferences',
              onTap: () {
                Get.to(() => PrivacyPage());
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
              onTap: () async {
                await StorageService.clear();
                Get.offAll(() => Loginscreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
