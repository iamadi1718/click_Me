import 'package:click_me/controller/likecontroller/profile_controller.dart';
import 'package:click_me/view/editprofilepage/Editprofilepage.dart';
import 'package:click_me/view/followersScreen/FollowersScreen.dart';
import 'package:click_me/view/followingScreen.dart/FollowingScreen.dart';
import 'package:click_me/view/postswidget/Postswidget.dart';
import 'package:click_me/view/savedwidget/Savedwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/view/utils/Api.dart';

class Profilepage extends StatelessWidget {
  Profilepage({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.rxProfile.value == null || controller.rxProfile.value!.data == null) {
          return const Center(child: Text("No Profile Found"));
        }

        final profile = controller.rxProfile.value!.data!;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: NetworkImage(
                      "${Api.baseUrl}${profile.profileImage}",
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          profile.username ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _profilestat(
                              profile.totalPosts.toString(),
                              "Posts",
                              () {},
                            ),
                            _profilestat(
                              profile.followersCount.toString(),
                              "Followers",
                              () {
                                Get.to(() => const FollowersScreen());
                              },
                            ),
                            _profilestat(
                              profile.followingCount.toString(),
                              "Following",
                              () {
                                Get.to(() => const FollowingScreen());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Text(
                "${profile.firstName ?? ""} ${profile.lastName ?? ""}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(profile.bio ?? ""),
              SizedBox(height: height * 0.03),
              InkWell(
                onTap: () {
                  Get.to(() => Editprofilepages());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(114, 111, 220, 1),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(114, 111, 220, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              InkWell(
                onTap: () {},
                child: const CircleAvatar(
                  radius: 26,
                  child: Center(child: Icon(Icons.add)),
                ),
              ),
              const Text('highlights'),
              const Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.changeTab(0);
                    },
                    child: Icon(
                      Icons.grid_view,
                      size: 34,
                      color: controller.selectedTab.value == 0
                          ? const Color.fromRGBO(85, 13, 155, 1)
                          : Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.changeTab(1);
                    },
                    child: Icon(
                      Icons.movie_creation_outlined,
                      size: 34,
                      color: controller.selectedTab.value == 1
                          ? const Color.fromRGBO(85, 13, 155, 1)
                          : Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.changeTab(2);
                    },
                    child: Icon(
                      Icons.person_add_alt_1_outlined,
                      size: 34,
                      color: controller.selectedTab.value == 2
                          ? const Color.fromRGBO(85, 13, 155, 1)
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1),
              Expanded(
                child: controller.selectedTab.value == 0
                    ? Postswidget()
                    : controller.selectedTab.value == 1
                        ? Savedwidget()
                        : Postswidget(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget _profilestat(String value, String title, VoidCallback? onTaps) {
  return InkWell(
    onTap: onTaps,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 15, color: Colors.black)),
      ],
    ),
  );
}
