import 'package:click_me/controller/likecontroller/startlive_controller.dart';
import 'package:click_me/view/dashboardpage/Dashboardpage.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class EndLiveScreen extends StatelessWidget {
  const EndLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Safely find or instantiate the StartLiveController
    final controller =
        Get.isRegistered<StartLiveController>()
            ? Get.find<StartLiveController>()
            : Get.put(StartLiveController());

    controller.initCamera();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await controller.endLive();
        Get.offAll(() => Dashboardpage());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Camera Preview Container with rounded bottom corners
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Camera Preview or Fallback Background Image
                      Positioned.fill(
                        child: Obx(() {
                          if (controller.isCameraInitialized.value) {
                            final matrix =
                                StartLiveController.filters[controller
                                    .selectedFilterIndex
                                    .value]['matrix'];

                            Widget cameraWidget = RTCVideoView(
                              controller.localRenderer,
                              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                            );

                            if (matrix != null) {
                              cameraWidget = ColorFiltered(
                                colorFilter: ColorFilter.matrix(
                                  List<double>.from(matrix),
                                ),
                                child: cameraWidget,
                              );
                            }

                            return SizedBox.expand(child: cameraWidget);
                          } else {
                            return Image.asset(
                              "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
                              fit: BoxFit.cover,
                            );
                          }
                        }),
                      ),
                      // Dark semi-transparent overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withAlpha((255 * 0.5).round()),
                                Colors.transparent,
                                Colors.black.withAlpha((255 * 0.6).round()),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Header Overlay (Back Button + Title + Filter Icon)
                      Positioned(
                        top: 16,
                        left: 8,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Back button triggers API to end the live stream
                                IconButton(
                                  onPressed: () async {
                                    await controller.endLive();
                                    Get.offAll(() => Dashboardpage());
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "End ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: "LIVE",
                                        style: TextStyle(
                                          color: Color(
                                            0xFF8685EF,
                                          ), // Periwinkle/lavender matching theme
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Filter Icon at the top right of the row
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: FilterIcon(size: 26),
                            ),
                          ],
                        ),
                      ),
                      // Right Side Vertical Icons Panel (Co-host + Viewer Count)
                      Positioned(
                        top: 80,
                        right: 20,
                        child: Column(
                          children: [
                            // Dynamic Viewer Count Icon + Text from controller
                            Obx(
                              () => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.groups_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${controller.liveData.value?.viewerCount ?? 0}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Overlay Area (Comments + Likes/Heart)
                      Positioned(
                        bottom: 24,
                        left: 16,
                        right: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Comments Column (Left Side)
                            Expanded(
                              child: Obx(() {
                                if (controller.comments.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                // Limit to the latest 5 comments to fit the overlay layout
                                final latestComments =
                                    controller.comments.reversed
                                        .take(5)
                                        .toList()
                                        .reversed
                                        .toList();

                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: latestComments.length,
                                  separatorBuilder:
                                      (context, index) =>
                                          const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final comment = latestComments[index];
                                    // Show newer comments with full opacity, older with 0.55 opacity
                                    final double opacity =
                                        index == latestComments.length - 1
                                            ? 1.0
                                            : 0.55;

                                    return _buildComment(
                                      avatarUrl: comment.avatar,
                                      username: comment.username,
                                      text: comment.text,
                                      opacity: opacity,
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a comment row with profile image and styled text
  Widget _buildComment({
    required String avatarUrl,
    required String username,
    required String text,
    required double opacity,
  }) {
    final bool hasAvatar = avatarUrl.isNotEmpty;
    final String fullAvatarUrl = hasAvatar ? "${Api.baseUrl}$avatarUrl" : "";

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.purple.shade200,
          backgroundImage: hasAvatar ? NetworkImage(fullAvatarUrl) : null,
          child:
              !hasAvatar
                  ? Text(
                    username.isNotEmpty ? username[0].toUpperCase() : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  : null,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(
                color: Colors.white.withAlpha((255 * opacity).round()),
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: "$username ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: text,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Filter Icon widget (three overlapping circles)
class FilterIcon extends StatelessWidget {
  final double size;

  const FilterIcon({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Top circle
          Positioned(
            top: 2,
            child: Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
            ),
          ),
          // Bottom-left circle
          Positioned(
            bottom: 2,
            left: 1,
            child: Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
            ),
          ),
          // Bottom-right circle
          Positioned(
            bottom: 2,
            right: 1,
            child: Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

