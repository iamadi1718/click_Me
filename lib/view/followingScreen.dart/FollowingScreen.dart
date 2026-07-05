import 'package:click_me/Models/FollowingModel/FollowingModel.dart';
import 'package:click_me/controller/followingController/FollowingController.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
final FollowingController controller =
    Get.isRegistered<FollowingController>()
        ? Get.find<FollowingController>()
        : Get.put(FollowingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Following",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Obx(() {

  if (controller.isLoading.value) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (controller.filteredFollowing.isEmpty) {
    return const Center(
      child: Text("No Following Found"),
    );
  }

  return RefreshIndicator(
    onRefresh: controller.refreshData,
    child: Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: controller.search,
            decoration: InputDecoration(
              hintText: "Search Following",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            physics:
                const AlwaysScrollableScrollPhysics(),
            itemCount:
                controller.filteredFollowing.length,
            itemBuilder: (context, index) {

              final user =
                  controller.filteredFollowing[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          user.profilePicture != null &&
                                  user.profilePicture!
                                      .isNotEmpty
                              ? NetworkImage(
                                  "${Api.baseUrl}${user.profilePicture}",
                                )
                              : null,
                      child:
                          user.profilePicture == null
                              ? const Icon(Icons.person)
                              : null,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            user.fullName ?? "",
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          Text(
                            "@${user.username}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// MESSAGE BUTTON
                    SizedBox(
                      width: 90,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {

                          /// Navigate to Chat Screen
                          /// Get.to(ChatScreen(user));

                        },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.deepPurple,
                        ),
                        child: const Text(
                          "Message",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    /// UNFOLLOW
                    SizedBox(
                      width: 95,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: controller
                                    .actionLoadingId
                                    .value ==
                                user.id
                            ? null
                            : () {
                                controller.unfollow(
                                  user.id!,
                                );
                              },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey,
                        ),
                        child: controller
                                    .actionLoadingId
                                    .value ==
                                user.id
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Unfollow",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}),);
  }
}
