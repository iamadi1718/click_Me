import 'package:click_me/Models/Homemodel/Homemodel.dart';
import 'package:click_me/Models/Storymodel/Storymodel.dart';
import 'package:click_me/controller/likecontroller/Likecontroller.dart';
import 'package:click_me/services/Homeservices/Homeservices.dart';
import 'package:click_me/services/Storyservices/Storyservices.dart';
import 'package:click_me/view/AddStory/AddStoryCard.dart';
import 'package:click_me/view/customposts/Customposts.dart';
import 'package:click_me/view/customstory/Customstory.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
          child: Divider(thickness: 2),
        ),
        FutureBuilder<StoryModel>(
          future: futureStory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 196,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: 196,
                child: Center(child: Text(snapshot.error.toString())),
              );
            }

            if (!snapshot.hasData ||
                snapshot.data!.data == null ||
                snapshot.data!.data!.stories == null) {
              return const SizedBox(
                height: 196,
                child: Center(child: Text("No Stories")),
              );
            }

            final users = snapshot.data!.data!.stories!;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Addstorycard(),
                  SizedBox(width: width * 0.05),

                  ...users.expand((user) {
                    return user.stories!.map((story) {
                      return Padding(
                        padding: EdgeInsets.only(right: width * 0.05),
                        child: Customstory(
                          bgimage: NetworkImage(
                            "${Api.baseUrl}${story.media?.url}",
                          ),
                          profileImage: NetworkImage(
                            "${Api.baseUrl}${user.user?.profilePicture}",
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

                  image: NetworkImage("${Api.baseUrl}${post.media![0].url}"),

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
}
