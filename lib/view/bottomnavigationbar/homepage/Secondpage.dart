import 'package:click_me/view/bottomnavigationbar/homepage/Postspage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Reelspage.dart';

import 'package:flutter/material.dart';

class Secondpage extends StatefulWidget {
  const Secondpage({super.key});

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
      
                /// Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
      
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "word",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 20,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: const Color(0xffF2F2F2),
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 8),
      
                /// TabBar
                const TabBar(
                  indicatorColor: Colors.black,
                  indicatorWeight: 2,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: "People"),
                    Tab(text: "Reels"),
                    Tab(text: "Posts/Pages"),
                  ],
                ),
      
                /// Your TabBarView
                Expanded(
                  child: TabBarView(
                    children: [
                      Container(), 
                      ReelsScreen(), 
                      PostsScreen(), 
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}