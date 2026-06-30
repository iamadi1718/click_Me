import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EndLiveScreen extends StatelessWidget {
  const EndLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Dark background matching the theme
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
                    // Background Image
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Dark semi-transparent overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
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
                          // Co-host Icon
                          IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.person_add_alt_1_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Viewer Count Icon + Text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.groups_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "47k",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Centered "#camera" Text
                    const Center(
                      child: Text(
                        "#camera",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildComment(
                                  imagePath:
                                      "assets/images/d68f7fe5e241018c89f66e7f3c31adf22f5f0370.jpg",
                                  text: "Comments long ago",
                                  opacity: 0.55,
                                ),
                                const SizedBox(height: 12),
                                _buildComment(
                                  imagePath:
                                      "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
                                  text: "Comments according to time",
                                  opacity: 0.55,
                                ),
                                const SizedBox(height: 12),
                                _buildComment(
                                  imagePath: "assets/images/chill.jpg",
                                  text: "Comments will keep disappearing",
                                  opacity: 0.55,
                                ),
                                const SizedBox(height: 12),
                                _buildComment(
                                  imagePath:
                                      "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
                                  text: "Comments written before",
                                  opacity: 0.55,
                                ),
                                const SizedBox(height: 12),
                                _buildComment(
                                  imagePath: "assets/images/chill.jpg",
                                  text: "Comments in real-time",
                                  opacity: 1.0,
                                ),
                              ],
                            ),
                          ),
                          // Heart Icon + Likes Count (Right Side)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "33k",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }

  // Helper method to build a comment row with profile image and styled text
  Widget _buildComment({
    required String imagePath,
    required String text,
    required double opacity,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 14, backgroundImage: AssetImage(imagePath)),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(opacity),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
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
