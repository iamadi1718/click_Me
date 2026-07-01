import 'package:click_me/Models/Homemodel/Homemodel.dart';
import 'package:click_me/Models/Storymodel/Storymodel.dart';
import 'package:click_me/controller/likecontroller/Likecontroller.dart';
import 'package:click_me/controller/likecontroller/story_feed_controller.dart';
import 'package:click_me/services/Homeservices/Homeservices.dart';
import 'package:click_me/view/AddStory/AddStoryCard.dart';
import 'package:click_me/view/customposts/Customposts.dart';
import 'package:click_me/view/customstory/Customstory.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/storyview/story_view_screen.dart';
import 'package:click_me/services/Profileservices/Profileservices.dart';
import 'package:click_me/Models/ProfileModel/ProfileModel.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  late final LikeController likeController;
  late final StoryFeedController storyFeedController;
  Future<HomeModel>? futureHome;
  Future<ProfileModel>? futureProfile;

  @override
  void initState() {
    super.initState();
    likeController = Get.isRegistered<LikeController>()
        ? Get.find<LikeController>()
        : Get.put(LikeController());
    storyFeedController = Get.isRegistered<StoryFeedController>()
        ? Get.find<StoryFeedController>()
        : Get.put(StoryFeedController());
    futureHome = HomeService().getHomeData();
    futureProfile = ProfileService().getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
          child: Divider(thickness: 2),
        ),
        FutureBuilder<ProfileModel>(
          future: futureProfile,
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 196,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (profileSnapshot.hasError) {
              // Profile API failed (e.g. server 500 error) — fall back gracefully using local user id
              final fallbackId = StorageService.getUserId();
              return _buildStorySection(width, null, fallbackId);
            }

            if (!profileSnapshot.hasData || profileSnapshot.data == null) {
              final fallbackId = StorageService.getUserId();
              return _buildStorySection(width, null, fallbackId);
            }

            final profileData = profileSnapshot.data!;
            final currentUserId = profileData.data?.id ?? StorageService.getUserId();

            return _buildStorySection(width, profileData, currentUserId);
          },
        ),
        SizedBox(height: height * 0.03),
        FutureBuilder<HomeModel>(
          future: futureHome,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text("No Data"));
            }

            final posts = snapshot.data!.data!.posts!;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                likeController.initialize(index, post.likesCount ?? 0);

                return Customposts(
                  index: index,
                  title:
                      "${post.userId?.firstName ?? ""} ${post.userId?.lastName ?? ""}",

                  time: post.createdAt ?? "",

                  image: post.media != null &&
                          post.media!.isNotEmpty &&
                          post.media![0].url != null &&
                          post.media![0].url!.isNotEmpty
                      ? NetworkImage("${Api.baseUrl}${post.media![0].url}")
                      : const AssetImage("assets/images/chill.jpg") as ImageProvider,

                  iconno: post.likesCount.toString(),

                  comment: post.commentsCount.toString(),

                  send: post.sharesCount.toString(),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildStorySection(double width, dynamic profileData, String? currentUserId) {
    return Obx(() {
      if (storyFeedController.isLoading.value && storyFeedController.rxStory.value == null) {
        return const SizedBox(
          height: 196,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (storyFeedController.error.value.isNotEmpty && storyFeedController.rxStory.value == null) {
        return const SizedBox(
          height: 196,
          child: Center(child: Text("Could not load stories")),
        );
      }

      final storyData = storyFeedController.rxStory.value;
      if (storyData == null || storyData.data == null || storyData.data!.stories == null) {
        return const SizedBox(
          height: 196,
          child: Center(child: Text("No Stories")),
        );
      }

      final users = storyData.data!.stories!;
      final effectiveUserId = currentUserId ?? StorageService.getUserId();

      StoryUser? currentUserStory;
      final otherUsers = <StoryUser>[];
      for (var u in users) {
        if (u.user?.id == effectiveUserId) {
          currentUserStory = u;
        } else {
          otherUsers.add(u);
        }
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 10),
            Addstorycard(currentUserStory: currentUserStory),
            SizedBox(width: width * 0.05),
            ...otherUsers.expand((user) {
              return user.stories!.map((story) {
                return Padding(
                  padding: EdgeInsets.only(right: width * 0.05),
                  child: Customstory(
                    bgimage:
                        story.media?.url != null && story.media!.url!.isNotEmpty
                            ? NetworkImage("${Api.baseUrl}${story.media!.url}")
                            : const AssetImage("assets/images/chill.jpg") as ImageProvider,
                    profileImage:
                        user.user?.profilePicture != null && user.user!.profilePicture!.isNotEmpty
                            ? NetworkImage("${Api.baseUrl}${user.user!.profilePicture}")
                            : const AssetImage("assets/images/profile.jpg") as ImageProvider,
                    text: "${user.user?.firstName ?? ""} ${user.user?.lastName ?? ""}",
                    onTap: () {
                      final mediaUrl = story.media?.url != null && story.media!.url!.isNotEmpty
                          ? "${Api.baseUrl}${story.media!.url}"
                          : "";
                      final profileUrl = user.user?.profilePicture != null && user.user!.profilePicture!.isNotEmpty
                          ? "${Api.baseUrl}${user.user!.profilePicture}"
                          : "";
                      Get.to(
                        () => StoryViewScreen(
                          mediaUrl: mediaUrl,
                          username: "${user.user?.firstName ?? ""} ${user.user?.lastName ?? ""}",
                          profileImage: profileUrl,
                          caption: story.caption,
                          timeAgo: "Just now",
                          storyId: story.id,             // ← pass storyId
                          isMyStory: false,
                        ),
                      );
                    },
                  ),
                );
              });
            }),
          ],
        ),
      );
    });
  }
}

