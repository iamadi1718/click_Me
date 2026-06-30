import 'package:click_me/Models/Storymodel/Storymodel.dart';
import 'package:click_me/view/storyview/story_view_screen.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Create Story/create_story.dart';

class Addstorycard extends StatelessWidget {
  final StoryUser? currentUserStory;
  const Addstorycard({super.key, this.currentUserStory});

  @override
  Widget build(BuildContext context) {
    final storyPosted = currentUserStory != null &&
        currentUserStory!.stories != null &&
        currentUserStory!.stories!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (storyPosted) {
          final lastStory = currentUserStory!.stories!.last;
          Get.to(() => StoryViewScreen(
                mediaUrl: "${Api.baseUrl}${lastStory.media?.url}",
                username: "My Story",
                profileImage: currentUserStory!.user?.profilePicture != null
                    ? "${Api.baseUrl}${currentUserStory!.user!.profilePicture}"
                    : "https://via.placeholder.com/150",
                caption: lastStory.caption,
                timeAgo: "Just now",
                storyId: lastStory.id,
                isMyStory: true,
                viewsCount: lastStory.viewsCount ?? lastStory.viewCount,
              ));
        } else {
          Get.to(() => const CreateStoryScreen());
        }
      },
      child: Container(
        height: 196,
        width: 112,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
          image: storyPosted
              ? DecorationImage(
                  image: NetworkImage(
                    "${Api.baseUrl}${currentUserStory!.stories!.last.media?.url}",
                  ),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Top section for placeholder state
            if (!storyPosted)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              )
            else
              // User avatar with small overlapping "+" badge
              Positioned(
                top: 10,
                left: 10,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: currentUserStory!.user?.profilePicture != null
                          ? NetworkImage(
                              "${Api.baseUrl}${currentUserStory!.user!.profilePicture}",
                            )
                          : const AssetImage("assets/images/img1.png")
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const CreateStoryScreen());
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Center large Plus button (only shown when no story is posted)
            if (!storyPosted)
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 22),
                  ),
                ),
              ),

            // Bottom Text
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  storyPosted ? 'My Story' : 'Add Story',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: storyPosted ? Colors.white : Colors.black,
                    shadows: storyPosted
                        ? [
                            const Shadow(
                              color: Colors.black45,
                              offset: Offset(1, 1),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
