import 'package:click_me/controller/likecontroller/startlive_controller.dart';
import 'package:click_me/view/CreateLive_Screen/End_Live.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class StartLiveScreen extends StatefulWidget {
  const StartLiveScreen({super.key});

  @override
  State<StartLiveScreen> createState() => _StartLiveScreenState();
}

class _StartLiveScreenState extends State<StartLiveScreen> {
  late final StartLiveController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StartLiveController());
    controller.initCamera();
  }

  @override
  void dispose() {
    controller.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF4C1D95); // Deep premium purple matching the screenshot

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Camera Preview Container with rounded bottom corners
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Camera Preview with Filters
                    Positioned.fill(
                      child: Obx(() {
                        if (controller.isCameraInitialized.value) {
                          final matrix = StartLiveController.filters[
                              controller.selectedFilterIndex.value]['matrix'];

                          Widget cameraWidget = RTCVideoView(
                            controller.localRenderer,
                            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                          );

                          // Apply filter if selected
                          if (matrix != null) {
                            cameraWidget = ColorFiltered(
                              colorFilter: ColorFilter.matrix(List<double>.from(matrix)),
                              child: cameraWidget,
                            );
                          }

                          return SizedBox.expand(
                            child: cameraWidget,
                          );
                        } else if (controller.isCameraPermissionDenied.value) {
                          return Container(
                            color: Colors.black87,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.videocam_off_rounded, color: Colors.white, size: 60),
                                SizedBox(height: 12),
                                Text(
                                  "Camera permission denied or camera not found",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
                                fit: BoxFit.cover,
                              ),
                              const Center(
                                child: CircularProgressIndicator(color: themeColor),
                              ),
                            ],
                          );
                        }
                      }),
                    ),

                    // Dark semi-transparent overlay for contrast
                    Positioned.fill(
                      child: Container(color: Colors.black.withAlpha((255 * 0.25).round())),
                    ),

                    // Header Overlay (Back Button + Title + Switch Camera)
                    Positioned(
                      top: 16,
                      left: 8,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Start a LIVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Obx(() {
                            if (controller.isCameraInitialized.value) {
                              return IconButton(
                                onPressed: () {
                                  controller.switchCamera();
                                },
                                icon: const Icon(
                                  Icons.flip_camera_ios_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ),


                    // Filter Slider Overlay (Horizontal scrollable list)
                    Positioned(
                      bottom: 20, // Sits perfectly at the bottom of the card
                      left: 0,
                      right: 0,
                      child: Obx(() {
                        if (controller.showFilters.value) {
                          return SizedBox(
                            height: 85,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: StartLiveController.filters.length,
                              itemBuilder: (context, index) {
                                final filter = StartLiveController.filters[index];
                                final isSelected = controller.selectedFilterIndex.value == index;
                                final colors = filter['colors'] as List<Color>;

                                return GestureDetector(
                                  onTap: () {
                                    controller.selectedFilterIndex.value = index;
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: colors,
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            border: Border.all(
                                              color: isSelected ? Colors.white : Colors.white24,
                                              width: isSelected ? 3 : 1.5,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: Colors.white.withAlpha((255 * 0.4).round()),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                    )
                                                  ]
                                                : null,
                                          ),
                                          child: isSelected
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.check_rounded,
                                                    color: Colors.deepPurple,
                                                    size: 24,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          filter['name'],
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.white70,
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            shadows: const [
                                              Shadow(
                                                color: Colors.black54,
                                                offset: Offset(0, 1),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Action Control Panel
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Left button: Filter icon (three overlapping circles)
                  GestureDetector(
                    onTap: () {
                      controller.showFilters.toggle();
                    },
                    child: Obx(() => Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: controller.showFilters.value
                                ? Colors.deepPurple.shade300
                                : themeColor,
                            border: controller.showFilters.value
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                          ),
                          child: const Center(child: FilterIcon()),
                        )),
                  ),
                  // Center button: Go Live play button (Trigger API call)
                  GestureDetector(
                    onTap: () async {
                      if (!controller.isLoading.value) {
                        final success = await controller.startLive();
                        if (success) {
                          Get.to(() => const EndLiveScreen());
                        }
                      }
                    },
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: themeColor, width: 2),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Obx(() => controller.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: themeColor,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Icon(
                                  Icons.play_arrow_rounded,
                                  color: themeColor,
                                  size: 40,
                                )),
                        ),
                      ),
                    ),
                  ),
                  // Right button: Co-host icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: themeColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget to draw three overlapping circles matching the filter icon in the screenshot
class FilterIcon extends StatelessWidget {
  const FilterIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Top circle
          Positioned(
            top: 3,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.2),
              ),
            ),
          ),
          // Bottom-left circle
          Positioned(
            bottom: 3,
            left: 1,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.2),
              ),
            ),
          ),
          // Bottom-right circle
          Positioned(
            bottom: 3,
            right: 1,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
