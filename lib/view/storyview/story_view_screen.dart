import 'package:click_me/controller/likecontroller/story_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryViewScreen extends StatefulWidget {
  final String mediaUrl;
  final String username;
  final String profileImage;
  final String? caption;
  final String? timeAgo;
  final String? storyId;
  final bool isMyStory;
  final int? viewsCount;

  const StoryViewScreen({
    super.key,
    required this.mediaUrl,
    required this.username,
    required this.profileImage,
    this.caption,
    this.timeAgo,
    this.storyId,
    this.isMyStory = false,
    this.viewsCount,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  late final StoryViewController controller;
  late final String uniqueTag;

  @override
  void initState() {
    super.initState();
    // Use a unique tag for this screen instance to prevent dependency injection collisions
    uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();
    controller = Get.put(StoryViewController(), tag: uniqueTag);
  }

  @override
  void dispose() {
    // Delete the instance registered with the unique tag to prevent memory leaks
    Get.delete<StoryViewController>(tag: uniqueTag, force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      // Validate URLs to prevent image rendering crash
      final isValidMedia = widget.mediaUrl.isNotEmpty &&
          widget.mediaUrl.startsWith("http") &&
          !widget.mediaUrl.endsWith("null");

      final isValidProfile = widget.profileImage.isNotEmpty &&
          widget.profileImage.startsWith("http") &&
          !widget.profileImage.endsWith("null");

      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Story Image
            Positioned.fill(
              child: GestureDetector(
                onTapDown: (_) {
                  // Pause timer on hold
                  controller.pauseProgress();
                },
                onTapUp: (_) {
                  // Resume timer on release
                  controller.resumeProgress();
                },
                child: isValidMedia
                    ? Image.network(
                        widget.mediaUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              "Failed to load story image",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "No story media found",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
              ),
            ),

            // Top Overlays
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Indicator Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Obx(() => LinearProgressIndicator(
                          value: controller.progress.value,
                          backgroundColor: Colors.white30,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 3,
                        )),
                  ),
                  const SizedBox(height: 12),

                  // User details & Close/Delete Buttons
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: isValidProfile
                            ? NetworkImage(widget.profileImage)
                            : const AssetImage("assets/images/img1.png") as ImageProvider,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (widget.timeAgo != null)
                            Text(
                              widget.timeAgo!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      // Delete Button (only for user's own stories)
                      if (widget.isMyStory && widget.storyId != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                          onPressed: () {
                            // Show confirmation dialog before deleting
                            Get.defaultDialog(
                              title: "Delete Story",
                              middleText: "Are you sure you want to delete this story?",
                              textCancel: "Cancel",
                              textConfirm: "Delete",
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red,
                              onCancel: () {
                                controller.resumeProgress();
                              },
                              onConfirm: () {
                                Get.back(); // close dialog
                                controller.deleteCurrentStory(widget.storyId!);
                              },
                            );
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Overlays (Caption + View Count)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Caption Overlay
                  if (widget.caption != null && widget.caption!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.caption!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // View Count (shown at the bottom-left of screen)
                  if (widget.isMyStory)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${widget.viewsCount ?? 0} Views",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Loading overlay
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      );
    } catch (e, stackTrace) {
      // Diagnostic rendering to display exact stack traces for any widget tree build crash
      return Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SelectableText(
              "StoryView Build Error:\n$e\n\n$stackTrace",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      );
    }
  }
}
