import 'package:click_me/view/bottomnavigationbar/friendspage/Friendspage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Homepage.dart';
import 'package:click_me/view/bottomnavigationbar/mediapage/Mediapage.dart';
import 'package:click_me/view/bottomnavigationbar/profilepage/Profilepage.dart';
import 'package:click_me/view/bottomnavigationbar/searchreels/Reelspage.dart';
import 'package:flutter/material.dart';

class Dashboardpage extends StatefulWidget {
  const Dashboardpage({super.key});

  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {
  int selectedindex = 0;
  final List<Widget> pages = [
    Homepage(),
    Friendspage(),
    Mediapage(),

    Reelspage(),
    Profilepage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedindex,
        onTap: (index) {
          setState(() {});
          selectedindex = index;
        },
        items: [
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
    );
  }
}
