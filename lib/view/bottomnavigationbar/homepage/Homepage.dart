import 'package:click_me/Models/Homemodel/Homemodel.dart';
import 'package:click_me/Models/Storymodel/Storymodel.dart';
import 'package:click_me/controller/likecontroller/Likecontroller.dart';
import 'package:click_me/services/Homeservices/Homeservices.dart';
import 'package:click_me/services/Storyservices/Storyservices.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Firstpage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Secondpage.dart';

import 'package:flutter/material.dart';
import 'package:click_me/view/Saved%20Audio/Saved_Audio.dart';
import 'package:click_me/view/NotificationScreen/Notification.dart';
import 'package:click_me/view/Chat_QueueScreen/Chat_Queue.dart';
import 'package:click_me/view/settingspage/Settingspage.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final LikeController likeController = Get.put(LikeController());
  Future<HomeModel>? futureHome;
  Future<StoryModel>? futureStory;
  @override
  void initState() {
    super.initState();
    futureHome = HomeService().getHomeData();
    futureStory = StoryService().getStoryData();
  }



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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SavedAudio(),
                          ),
                        );
                      },
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                    SizedBox(width: width * 0.35),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatQueue(),
                          ),
                        );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Color.fromRGBO(222, 222, 222, 1),
                    ),
                    child: TextField(
                     
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Secondpage(),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10),
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search your vibe',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                 Firstpage()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
