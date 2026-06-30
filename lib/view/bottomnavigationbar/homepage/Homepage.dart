import 'package:click_me/view/bottomnavigationbar/homepage/Firstpage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Secondpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/view/Saved%20Audio/Saved_Audio.dart';
import 'package:click_me/view/NotificationScreen/Notification.dart';
import 'package:click_me/view/Chat_QueueScreen/Chat_Queue.dart';
import 'package:click_me/view/settingspage/Settingspage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/clickME.png',
                      width: 92,
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SavedAudio());
                      },
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                    SizedBox(width: width * 0.35),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const NotificationScreen());
                      },
                      child: const Icon(
                        Icons.notification_add,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ChatQueue());
                      },
                      child: const Icon(
                        Icons.chat,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SettingsPage());
                      },
                      child: const Icon(
                        Icons.menu,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color.fromRGBO(222, 222, 222, 1),
                    ),
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        Get.to(() => const Secondpage());
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10),
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search your vibe',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Firstpage()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
