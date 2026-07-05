import 'package:click_me/Models/followRequestsModel/FollowRequestsModel.dart';
import 'package:click_me/controller/follow_request_controller/FollowRequestController.dart';

import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowRequestsScreen extends StatefulWidget {
  const FollowRequestsScreen({super.key});

  @override
  State<FollowRequestsScreen> createState() => _FollowRequestsScreenState();
}

class _FollowRequestsScreenState extends State<FollowRequestsScreen> {
  final FollowRequestsController controller =
    Get.isRegistered<FollowRequestsController>()
        ? Get.find<FollowRequestsController>()
        : Get.put(FollowRequestsController());

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Follow Requests",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

     body: Obx(() {

  if (controller.isLoading.value) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (controller.filteredRequests.isEmpty) {
    return const Center(
      child: Text("No Follow Requests"),
    );
  }

  return RefreshIndicator(
    onRefresh: controller.loadRequests,
    child: Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: controller.search,
            decoration: InputDecoration(
              hintText: "Search Requests",
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
                controller.filteredRequests.length,
            itemBuilder: (context, index) {

              final request =
                  controller.filteredRequests[index];

              final user = request.requester;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          user?.profilePicture != null
                              ? NetworkImage(
                                  "${Api.baseUrl}${user!.profilePicture}",
                                )
                              : null,
                      child:
                          user?.profilePicture == null
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
                            "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          Text(
                            request.status ?? "",
                            style:
                                const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ALLOW BUTTON
                    SizedBox(
                      width: 80,
                      height: 36,
                      child: ElevatedButton(
                        onPressed:
                            controller.actionLoadingId
                                        .value ==
                                    user?.id
                                ? null
                                : () {
                                    controller.acceptRequest(request.id!);
                                  },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.deepPurple,
                        ),
                        child:
                            controller.actionLoadingId
                                        .value ==
                                    user?.id
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Allow",
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

                    /// REJECT BUTTON
                    SizedBox(
                      width: 80,
                      height: 36,
                      child: ElevatedButton(
                        onPressed:
                            controller.actionLoadingId
                                        .value ==
                                    user?.id
                                ? null
                                : () {
                                    controller.rejectRequest(request.id!);
                                  },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey,
                        ),
                        child:
                            controller.actionLoadingId
                                        .value ==
                                    user?.id
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Reject",
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.white,
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

class FollowRequestTile extends StatelessWidget {
  final RequestData request;
  final Future<void> Function() onAllow;
  final Future<void> Function() onReject;

  const FollowRequestTile({
    super.key,
    required this.request,
    required this.onAllow,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final user = request.requester;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade300,
            backgroundImage:
                user?.profilePicture != null
                    ? NetworkImage("${Api.baseUrl}${user!.profilePicture}")
                    : null,
            child:
                user?.profilePicture == null ? const Icon(Icons.person) : null,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "@${user?.firstName?.toLowerCase() ?? "username"}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 80,
            height: 35,
            child: ElevatedButton(
              onPressed: () async {
                await onAllow();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                "Allow",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 85,
            height: 35,
            child: ElevatedButton(
              onPressed: () async {
                await onReject();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text(
                "Reject",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
