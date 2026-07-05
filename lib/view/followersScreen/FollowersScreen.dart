import 'package:click_me/controller/followerController/FollowerController.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
final FollowersController controller =
    Get.isRegistered<FollowersController>()
        ? Get.find<FollowersController>()
        : Get.put(FollowersController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Followers",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Obx(() {
  if (controller.isLoading.value) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (controller.filteredFollowers.isEmpty) {
    return const Center(
      child: Text("No Followers Found"),
    );
  }

  return RefreshIndicator(
    onRefresh: controller.refreshData,
    child: Column(
      children: [

        /// SEARCH
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: controller.search,
            decoration: InputDecoration(
              hintText: "Search followers",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade200,
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
                controller.filteredFollowers.length,
            itemBuilder: (context, index) {

              final user =
                  controller.filteredFollowers[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          user.profilePicture != null &&
                                  user.profilePicture!
                                      .isNotEmpty
                              ? NetworkImage(
                                  "${Api.baseUrl}${user.profilePicture}",
                                )
                              : null,
                      child:
                          user.profilePicture == null ||
                                  user.profilePicture!
                                      .isEmpty
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
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          Text(
                            "@${user.username}",
                            style:
                                const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// FOLLOW BACK
                    if (!(user.isFollowing ?? false))
                      SizedBox(
                        width: 110,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: controller
                                      .actionLoadingId
                                      .value ==
                                  user.id
                              ? null
                              : () {
                                  controller.followBack(
                                      user.id!);
                                },
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.deepPurple,
                          ),
                          child: controller
                                      .actionLoadingId
                                      .value ==
                                  user.id
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Follow Back",
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                        ),
                      ),

                    const SizedBox(width: 8),

                    /// REMOVE
                    SizedBox(
                      width: 90,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: controller
                                    .actionLoadingId
                                    .value ==
                                user.id
                            ? null
                            : () {
                                controller
                                    .removeFollower(
                                        user.id!);
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
                                height: 18,
                                width: 18,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Remove",
                                style: TextStyle(
                                  color: Colors.white,
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
}), );
  }
}
