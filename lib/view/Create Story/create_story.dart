import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/view/CreateLive_Screen/Start_Live.dart';
import '../../controller/likecontroller/Create_Story_controller.dart';


class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final controller = Get.put(CreateStoryController());

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white, // White background behind preview card so rounded corners show white
      body: Column(
        children: [
          // 1. Preview Area
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(36),
              ),
              child: Stack(
                children: [
                  // Background Image (acting as camera preview)
                  Positioned.fill(
                    child: Obx(() {
                      final picked = controller.pickedFile.value;
                      if (picked != null) {
                        return Image.file(
                          picked,
                          fit: BoxFit.cover,
                        );
                      }
                      return Image.asset(
                        'assets/images/flowers_story.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback in case the image fails to load
                          return Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white24,
                                size: 64,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  // Doodles Painter
                  Obx(() {
                    if (controller.pickedFile.value != null) {
                      return const SizedBox.shrink();
                    }
                    return Positioned.fill(
                      child: CustomPaint(
                        painter: DoodlesPainter(),
                      ),
                    );
                  }),

                  // Top Header Overlay (Back Button + Title)
                  Positioned(
                    top: statusBarHeight + 12,
                    left: 8,
                    right: 16,
                    child: Row(
                      children: [
                        Obx(() => IconButton(
                          icon: Icon(
                            controller.pickedFile.value != null
                                ? Icons.close
                                : Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            if (controller.pickedFile.value != null) {
                              controller.clearPickedFile();
                            } else {
                              Get.back();
                            }
                          },
                        )),
                        const SizedBox(width: 8),
                        Obx(() {
                          if (controller.pickedFile.value != null) {
                            return const SizedBox.shrink();
                          }
                          return const Text(
                            'Create with clickME',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  offset: Offset(1, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // "Golden Hour" slanted text doodle
                  Obx(() {
                    if (controller.pickedFile.value != null) {
                      return const SizedBox.shrink();
                    }
                    return Positioned(
                      top: statusBarHeight + 90,
                      right: 40,
                      child: Transform.rotate(
                        angle: -0.15,
                        child: const Text(
                          '<<< golden hour',
                          style: TextStyle(
                            color: Color(0xFFD5A9A0),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0.5, 0.5),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Center Hashtag Text
                  Obx(() {
                    if (controller.pickedFile.value != null) {
                      return const SizedBox.shrink();
                    }
                    return Center(
                      child: const Text(
                        '#camera',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(1.5, 1.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // 2. Bottom Controls Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gallery Thumbnail Stack
                  GestureDetector(
                    onTap: () {
                      controller.pickFromGallery();
                    },
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Third photo (most rotated, back)
                          Transform.rotate(
                            angle: -0.22,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black, width: 1.5),
                              ),
                            ),
                          ),
                          // Second photo (middle)
                          Transform.rotate(
                            angle: -0.12,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black, width: 1.5),
                              ),
                            ),
                          ),
                          // First photo (front, straight)
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black, width: 2),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/story2.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Shutter Button
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const SizedBox(
                        width: 76,
                        height: 76,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF6B4EFF),
                          ),
                        ),
                      );
                    }
                    
                    final hasFile = controller.pickedFile.value != null;
                    
                    return GestureDetector(
                      onTap: () {
                        if (hasFile) {
                          controller.uploadStory();
                        } else {
                          controller.captureStory();
                        }
                      },
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF6B4EFF),
                            width: 3,
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasFile ? const Color(0xFF6B4EFF) : Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: hasFile
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 36,
                                )
                              : null,
                        ),
                      ),
                    );
                  }),

                  // Dropdown / Mode Selector
                  Obx(
                    () => PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'Live') {
                          Get.to(() => const StartLiveScreen());
                        } else {
                          controller.changeMode(value);
                          Get.snackbar(
                            'Mode Changed',
                            'Switched to $value mode',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                            margin: const EdgeInsets.all(16),
                          );
                        }
                      },
                      offset: const Offset(0, -140), // Pop up above the selector
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Story',
                          child: Row(
                            children: [
                              Icon(
                                Icons.amp_stories_outlined,
                                color: controller.selectedMode.value == 'Story'
                                    ? const Color(0xFF6B4EFF)
                                    : Colors.black54,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Story',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: controller.selectedMode.value == 'Story'
                                      ? const Color(0xFF6B4EFF)
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Reel',
                          child: Row(
                            children: [
                              Icon(
                                Icons.video_collection_outlined,
                                color: controller.selectedMode.value == 'Reel'
                                    ? const Color(0xFF6B4EFF)
                                    : Colors.black54,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Reel',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: controller.selectedMode.value == 'Reel'
                                      ? const Color(0xFF6B4EFF)
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Live',
                          child: Row(
                            children: [
                              Icon(
                                Icons.live_tv_outlined,
                                color: controller.selectedMode.value == 'Live'
                                    ? const Color(0xFF6B4EFF)
                                    : Colors.black54,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Live',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: controller.selectedMode.value == 'Live'
                                      ? const Color(0xFF6B4EFF)
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Create',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.selectedMode.value,
                                style: const TextStyle(
                                  color: Color(0xFF6B4EFF),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF6B4EFF),
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DoodlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pinkPaint = Paint()
      ..color = const Color(0xFFD5A9A0) // Mauve/pink doodle color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final yellowPaint = Paint()
      ..color = const Color(0xFFE2C48F) // Golden yellow doodle color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // 1. Draw Wavy Outline (wavy hand-drawn loop around the center)
    final loopPath = Path();
    final left = size.width * 0.08;
    final top = size.height * 0.12;
    final width = size.width * 0.84;
    final height = size.height * 0.70;

    loopPath.moveTo(left + width * 0.5, top);

    // Right side wiggles
    loopPath.cubicTo(left + width * 0.8, top - 10, left + width * 0.9, top + height * 0.15, left + width * 0.85, top + height * 0.25);
    loopPath.cubicTo(left + width * 0.75, top + height * 0.35, left + width * 0.95, top + height * 0.45, left + width * 0.92, top + height * 0.6);
    loopPath.cubicTo(left + width * 0.9, top + height * 0.75, left + width * 0.75, top + height * 0.82, left + width * 0.5, top + height * 0.85);

    // Left side wiggles
    loopPath.cubicTo(left + width * 0.25, top + height * 0.88, left + width * 0.08, top + height * 0.8, left + width * 0.12, top + height * 0.65);
    loopPath.cubicTo(left + width * 0.15, top + height * 0.55, left + width * 0.05, top + height * 0.4, left + width * 0.1, top + height * 0.25);
    loopPath.cubicTo(left + width * 0.15, top + height * 0.1, left + width * 0.3, top + 10, left + width * 0.5, top);

    canvas.drawPath(loopPath, pinkPaint);

    // 2. Draw Top-Left Spiral (Yellow)
    final tlSpiralPath = Path();
    double cx = left + width * 0.05;
    double cy = top + height * 0.2;
    tlSpiralPath.moveTo(cx, cy);
    for (double t = 0; t < 3 * math.pi; t += 0.1) {
      double r = 4.0 + (t * 1.5);
      double x = cx + r * math.cos(t - math.pi * 0.25);
      double y = cy + r * math.sin(t - math.pi * 0.25);
      if (t == 0) {
        tlSpiralPath.moveTo(x, y);
      } else {
        tlSpiralPath.lineTo(x, y);
      }
    }
    canvas.drawPath(tlSpiralPath, yellowPaint);

    // 3. Draw Bottom-Right Spiral (Yellow)
    final brSpiralPath = Path();
    double bx = left + width * 0.92;
    double by = top + height * 0.85;
    brSpiralPath.moveTo(bx, by);
    for (double t = 0; t < 3.5 * math.pi; t += 0.1) {
      double r = 3.0 + (t * 1.2);
      double x = bx + r * math.cos(t + math.pi * 0.5);
      double y = by + r * math.sin(t + math.pi * 0.5);
      if (t == 0) {
        brSpiralPath.moveTo(x, y);
      } else {
        brSpiralPath.lineTo(x, y);
      }
    }
    canvas.drawPath(brSpiralPath, yellowPaint);

    // 4. Draw Yellow Sparkles / Slashes (left and right)
    double sx1 = left + width * 0.02;
    double sy1 = top + height * 0.45;
    canvas.drawLine(Offset(sx1, sy1), Offset(sx1 - 10, sy1 - 5), yellowPaint);
    canvas.drawLine(Offset(sx1 + 2, sy1 + 8), Offset(sx1 - 8, sy1 + 10), yellowPaint);
    canvas.drawLine(Offset(sx1 + 5, sy1 + 16), Offset(sx1 - 3, sy1 + 22), yellowPaint);

    double sx2 = left + width * 0.95;
    double sy2 = top + height * 0.5;
    canvas.drawLine(Offset(sx2, sy2), Offset(sx2 + 10, sy2 + 5), yellowPaint);
    canvas.drawLine(Offset(sx2 - 2, sy2 + 8), Offset(sx2 + 8, sy2 + 12), yellowPaint);
    canvas.drawLine(Offset(sx2 - 5, sy2 + 16), Offset(sx2 + 3, sy2 + 22), yellowPaint);

    // 5. Draw Hearts (Pink)
    _drawHeart(canvas, pinkPaint, Offset(left + width * 0.12, top + height * 0.35), 7);
    _drawHeart(canvas, pinkPaint, Offset(left + width * 0.22, top + height * 0.72), 6);
    _drawHeart(canvas, pinkPaint, Offset(left + width * 0.88, top + height * 0.28), 6);
  }

  void _drawHeart(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(
      center.dx - size * 0.5, center.dy - size * 0.5,
      center.dx - size, center.dy + size * 0.2,
      center.dx, center.dy + size * 0.9,
    );
    path.cubicTo(
      center.dx + size, center.dy + size * 0.2,
      center.dx + size * 0.5, center.dy - size * 0.5,
      center.dx, center.dy + size * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
