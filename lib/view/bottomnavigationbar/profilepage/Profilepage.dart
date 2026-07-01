import 'dart:ui';

import 'package:click_me/controller/likecontroller/profile_controller.dart';
<<<<<<< HEAD
import 'package:click_me/view/bottomnavigationbar/profilepage/ProfileImageView.dart';
=======
import 'package:click_me/services/liveservices/live_check_service.dart';
import 'package:click_me/view/CreateLive_Screen/watch_live_screen.dart';
>>>>>>> 52a3752c2bfad51e83a02313ff8a62cb53f7761e
import 'package:click_me/view/editprofilepage/Editprofilepage.dart';
import 'package:click_me/view/followersScreen/FollowersScreen.dart';
import 'package:click_me/view/followingScreen.dart/FollowingScreen.dart';
import 'package:click_me/view/ExplorePostsScreen/ExplorePostsScreen.dart';
import 'package:click_me/view/ExplorePostsScreen/ExplorePostsScreen.dart';
import 'package:click_me/view/savedwidget/Savedwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/view/utils/api.dart';

class Profilepage extends GetView<ProfileController> {
  const Profilepage({super.key});

  @override
  ProfileController get controller =>
      Get.put(ProfileController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────────────────
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error ────────────────────────────────────────────────────
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                const Text(
                  'Could not load profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: controller.fetchProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // ── No Data ──────────────────────────────────────────────────
        if (controller.rxProfile.value == null ||
            controller.rxProfile.value!.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('No Profile Found'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: controller.fetchProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // ── Profile Content ──────────────────────────────────────────
        final profile = controller.rxProfile.value!.data!;
        final userId = profile.id ?? '';

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar + Live Badge + Stats ───────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
<<<<<<< HEAD
                 GestureDetector(
  onTap: () {
    Get.to(
      () => ProfileImageView(
        imageUrl: "${Api.baseUrl}${profile.profileImage}",
      ),
      transition: Transition.fade,
    );
  },
  child: Hero(
    tag: "${Api.baseUrl}${profile.profileImage}",
    child: CircleAvatar(
      radius: 42,
      backgroundImage: NetworkImage(
        "${Api.baseUrl}${profile.profileImage}",
      ),
    ),
  ),
),
 const SizedBox(width: 20),
=======
                  // Avatar with LIVE ring (fetched via FutureBuilder)
                  FutureBuilder<Map<String, String>?>(
                    future: userId.isNotEmpty
                        ? LiveCheckService().getUserActiveLive(userId)
                        : Future.value(null),
                    builder: (context, snapshot) {
                      final liveData = snapshot.data;
                      final isLive = liveData != null &&
                          liveData['streamId'] != null &&
                          liveData['streamId']!.isNotEmpty;

                      return GestureDetector(
                        onTap: isLive
                            ? () => Get.to(() => WatchLiveScreen(
                                  streamId: liveData['streamId'] as String,
                                  streamTitle: liveData['title'] ?? 'Live Stream',
                                  streamerName: profile.username ?? '',
                                ))
                            : null,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // LIVE ring when streaming
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isLive
                                      ? Colors.red
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 42,
                                backgroundImage: profile.profileImage != null &&
                                        profile.profileImage!.isNotEmpty
                                    ? NetworkImage(
                                        '${Api.baseUrl}${profile.profileImage}')
                                    : const AssetImage(
                                            'assets/images/profile.jpg')
                                        as ImageProvider,
                              ),
                            ),
                            // LIVE badge below avatar
                            if (isLive)
                              Positioned(
                                bottom: -8,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'LIVE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 20),

                  // Username + Stats
>>>>>>> 52a3752c2bfad51e83a02313ff8a62cb53f7761e
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          profile.username ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
<<<<<<< HEAD
                            _profilestat(
                              profile.totalPosts.toString(),
                              "Posts",
                              () {
                                
                              },
=======
                            _stat(
                              profile.totalPosts?.toString() ?? '0',
                              'Posts',
                              () {},
>>>>>>> 52a3752c2bfad51e83a02313ff8a62cb53f7761e
                            ),
                            _stat(
                              profile.followersCount?.toString() ?? '0',
                              'Followers',
                              () => Get.to(() => const FollowersScreen()),
                            ),
                            _stat(
                              profile.followingCount?.toString() ?? '0',
                              'Following',
                              () => Get.to(() => const FollowingScreen()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.03),

              // Name
              Text(
                '${profile.firstName ?? ''} ${profile.lastName ?? ''}'.trim(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Bio
              if (profile.bio != null && profile.bio!.isNotEmpty)
                Text(profile.bio!),

              SizedBox(height: height * 0.03),

              // Edit Profile button
              InkWell(
                onTap: () => Get.to(() => Editprofilepages()),
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

              // Highlights
              InkWell(
                onTap: () {},
                child: const CircleAvatar(
                  radius: 26,
                  child: Center(child: Icon(Icons.add)),
                ),
              ),
              const Text('highlights'),
              const Divider(thickness: 1),

              // Tab Icons
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => controller.changeTab(0),
                      child: Icon(
                        Icons.grid_view,
                        size: 34,
                        color: controller.selectedTab.value == 0
                            ? const Color.fromRGBO(85, 13, 155, 1)
                            : Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.changeTab(1),
                      child: Icon(
                        Icons.movie_creation_outlined,
                        size: 34,
                        color: controller.selectedTab.value == 1
                            ? const Color.fromRGBO(85, 13, 155, 1)
                            : Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.changeTab(2),
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
              ),
              const Divider(thickness: 1),

              // Tab Content
              Expanded(
<<<<<<< HEAD
                child: controller.selectedTab.value == 0
                    ? ExplorePostsScreen()
                    : controller.selectedTab.value == 1
                        ? Savedwidget()
                        : ExplorePostsScreen()
=======
                child: Obx(
                  () => controller.selectedTab.value == 0
                      ? Postswidget()
                      : controller.selectedTab.value == 1
                          ? Savedwidget()
                          : Postswidget(),
                ),
>>>>>>> 52a3752c2bfad51e83a02313ff8a62cb53f7761e
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Reusable stat widget ─────────────────────────────────────────────────────
Widget _stat(String value, String title, VoidCallback? onTap) {
  return InkWell(
    onTap: onTap,
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

