import 'package:click_me/controller/likecontroller/dashboard_controller.dart';
import 'package:click_me/view/bottomnavigationbar/friendspage/Friendspage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Homepage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/ReelBottomPage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Reelspage.dart';
import 'package:click_me/view/bottomnavigationbar/mediapage/Mediapage.dart';
import 'package:click_me/view/bottomnavigationbar/profilepage/Profilepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboardpage extends StatelessWidget {
  Dashboardpage({super.key});

  final controller = Get.put(DashboardController());

  final List<Widget> pages = [
    Homepage(),
    FriendsScreen(),
    Mediapage(),
    ReelBottomPage(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 32), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups, size: 32),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: 40),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined, size: 32),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 32),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
