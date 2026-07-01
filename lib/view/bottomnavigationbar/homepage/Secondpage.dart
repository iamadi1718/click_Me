import 'package:click_me/controller/SearchController/SearchController.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Postspage.dart';
import 'package:click_me/view/bottomnavigationbar/homepage/Reelspage.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';

class Secondpage extends StatefulWidget {
  const Secondpage({super.key});

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  final TextEditingController searchController = TextEditingController();

  final SearchController controller = Get.put(SearchController());

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            controller.search(value.trim());
                          },
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: const Color(0xffF2F2F2),
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

              const SizedBox(height: 10),

              const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "People"),
                  Tab(text: "Reels"),
                  Tab(text: "Posts/Pages"),
                ],
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (controller.users.isEmpty) {
                        return const Center(
                          child: Text("Search users"),
                        );
                      }

                      return ListView.builder(
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          final user = controller.users[index];

                          return ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: (user.profileImage != null &&
                                      user.profileImage!.isNotEmpty)
                                  ? NetworkImage(user.profileImage!)
                                  : null,
                              child: (user.profileImage == null ||
                                      user.profileImage!.isEmpty)
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(
                              user.fullName ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("@${user.username ?? ""}"),
                                if ((user.bio ?? "").isNotEmpty)
                                  Text(
                                    user.bio!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    user.isFollowing == true
                                        ? Colors.grey.shade300
                                        : Colors.blue,
                              ),
                              child: Text(
                                user.isFollowing == true
                                    ? "Following"
                                    : "Follow",
                                style: TextStyle(
                                  color: user.isFollowing == true
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),

                    const ReelsScreen(),

                    const PostsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}