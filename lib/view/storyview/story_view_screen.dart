import 'package:click_me/controller/likecontroller/story_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryViewScreen extends GetView<StoryViewController> {
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

  // Safe lazy controller instantiation, deletes automatically when screen is popped
  @override
  StoryViewController get controller => Get.put(StoryViewController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    final isValidUrl = mediaUrl.isNotEmpty &&
        mediaUrl.startsWith('http') &&
        !mediaUrl.contains('null');

    final isValidProfile = profileImage.isNotEmpty &&
        profileImage.startsWith('http') &&
        !profileImage.contains('null');

    // Initialize story parameters once safely
    controller.initStory(
      storyId: storyId,
      isMyStory: isMyStory,
      initialViews: viewsCount ?? 0,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (_) => controller.pauseProgress(),
        onTapUp: (_) => controller.resumeProgress(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background image ─────────────────────────────────────────
            if (isValidUrl)
              _StoryImage(url: mediaUrl)
            else
              const _NoMedia(),

            // ── Progress bar + User Info ──────────────────────────────────
            Positioned(
              top: topPad + 8,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: controller.progress.value.clamp(0.0, 1.0),
                          backgroundColor: Colors.white30,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 3,
                        ),
                      )),
                  const SizedBox(height: 10),
                  // User row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: isValidProfile
                            ? NetworkImage(profileImage)
                            : const AssetImage('assets/images/img1.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (timeAgo != null)
                              Text(
                                timeAgo!,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 10),
                              ),
                          ],
                        ),
                      ),
                      if (isMyStory && storyId != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.white, size: 26),
                          onPressed: () => controller.deleteCurrentStory(storyId!),
                        ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 26),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Bottom: caption + view count ────────────────────────────
            Positioned(
              bottom: botPad + 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (caption != null && caption!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        caption!,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15, height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (isMyStory)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.remove_red_eye_outlined,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '${controller.viewCount.value} Views',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                    ),
                ],
              ),
            ),

            // ── Deleting overlay ─────────────────────────────────────────
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

// ── Story Image widget ────────────────────────────────────────────────────────
class _StoryImage extends StatelessWidget {
  final String url;
  const _StoryImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
    );
  }
}

// ── No media placeholder ─────────────────────────────────────────────────────
class _NoMedia extends StatelessWidget {
  const _NoMedia();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_not_supported_outlined,
              color: Colors.white54, size: 64),
          SizedBox(height: 12),
          Text('No media available',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }
}
