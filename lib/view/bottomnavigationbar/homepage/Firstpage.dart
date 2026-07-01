import 'package:click_me/Models/Storymodel/Storymodel.dart';
import 'package:click_me/controller/HomeController/HomeController.dart';
import 'package:click_me/controller/likecontroller/Likecontroller.dart';
import 'package:click_me/services/Storyservices/Storyservices.dart';
import 'package:click_me/view/AddStory/AddStoryCard.dart';
import 'package:click_me/view/customposts/Customposts.dart';
import 'package:click_me/view/customstory/Customstory.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/controller/StoryController/StoryController.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final LikeController likeController = Get.put(LikeController());

  final HomeController homeController =
      Get.put(HomeController());

  final StoryController storyController =
    Get.put(StoryController());

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 0,
          ),
          child: Divider(thickness: 2),
        ),

        Obx(() {
  if (storyController.isLoading.value) {
    return const SizedBox(
      height: 196,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  if (storyController.errorMessage.value.isNotEmpty) {
    return SizedBox(
      height: 196,
      child: Center(
        child: Text(
          storyController.errorMessage.value,
        ),
      ),
    );
  }

  if (storyController.stories.isEmpty) {
    return const SizedBox(
      height: 196,
      child: Center(
        child: Text("No Stories"),
      ),
    );
  }

  final users = storyController.stories;

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        const Addstorycard(),
        SizedBox(width: width * 0.05),

        ...users.expand((user) {
          return (user.stories ?? []).map((story) {
            return Padding(
              padding: EdgeInsets.only(
                right: width * 0.05,
              ),
              child: Customstory(
                bgimage: NetworkImage(
                  "${Api.baseUrl}${story.media?.url ?? ""}",
                ),
                profileImage: NetworkImage(
                  "${Api.baseUrl}${user.user?.profilePicture ?? ""}",
                ),
                text:
                    "${user.user?.firstName ?? ""} ${user.user?.lastName ?? ""}",
              ),
            );
          });
        }).toList(),
      ],
    ),
  );
}),

        SizedBox(height: height * 0.03),

        /// HOME POSTS USING GETX
        Obx(() {
          if (homeController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (homeController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Text(
                homeController.errorMessage.value,
              ),
            );
          }

          if (homeController.posts.isEmpty) {
            return const Center(
              child: Text("No Posts"),
            );
          }

          final posts = homeController.posts;

          return ListView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              likeController.initialize(
                index,
                post.likesCount ?? 0,
              );

              return Customposts(
                index: index,

                title:
                    "${post.userId?.firstName ?? ""} ${post.userId?.lastName ?? ""}",

                time: post.createdAt ?? "",

                image: NetworkImage(
                  "${Api.baseUrl}${post.media![0].url}",
                ),

                iconno: post.likesCount.toString(),

                comment:
                    post.commentsCount.toString(),

                send:
                    post.sharesCount.toString(),
              );
            },
          );
        }),
      ],
    );
  }
}