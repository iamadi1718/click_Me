import 'package:click_me/controller/likecontroller/dashboard_controller.dart';
import 'package:click_me/controller/likecontroller/profile_controller.dart';
import 'package:click_me/view/bottomnavigationbar/friendspage/Friendspage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Homepage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/ReelBottomPage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Reelspage.dart';
import 'package:click_me/view/bottomnavigationbar/mediapage/Mediapage.dart';
import 'package:click_me/view/bottomnavigationbar/profilepage/Profilepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

 
import 'package:click_me/view/utils/api.dart';

class Dashboardpage extends StatefulWidget {
  Dashboardpage({super.key});

  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {
  final controller = Get.put(DashboardController());

final profileController = Get.put(ProfileController());

  final List<Widget> pages = [
    const Homepage(),
    FriendsScreen(),
    Mediapage(),

    ReelBottomPage(),
    Profilepage(),

    ReelsScreen(),
    const Profilepage(),

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
          items:  [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 32), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 32),
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
  icon: Builder(
    builder: (_) {
      final profile = profileController.rxProfile.value?.data;

      return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: controller.selectedIndex.value == 4
                ? const Color(0xff550D9B)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 14,
          backgroundImage: profile?.profileImage != null &&
                  profile!.profileImage!.isNotEmpty
              ? NetworkImage(
                  "${Api.baseUrl}${profile.profileImage}",
                )
              : const AssetImage(
                  "assets/images/profile.jpg",
                ) as ImageProvider,
        ),
      );
    },
  ),
  label: '',
),],
        ),
      ),
    );
  }
}
