import 'package:flutter/material.dart';

class PostPageItem {
  final String imagePath;
  final String likes;
  final String comments;
  final String shares;
  final bool hasBorder;

  const PostPageItem({
    required this.imagePath,
    required this.likes,
    required this.comments,
    required this.shares,
    this.hasBorder = false,
  });
}

class PostPagesSearchScreen extends StatelessWidget {
  const PostPagesSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine screen width to calculate exact cell sizes
    final double screenWidth = MediaQuery.of(context).size.width;
    const double padding = 4.0;
    const double spacing = 4.0;
    final double cellWidth = (screenWidth - (padding * 2) - (spacing * 2)) / 3;

    // Define the exact items from the screenshot using ONLY local asset images
    const celestialWoman = PostPageItem(
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
      likes: "33k",
      comments: "15k",
      shares: "373",
    );

    const cow = PostPageItem(
      imagePath: "assets/images/live.jpg",
      likes: "14k",
      comments: "101",
      shares: "10k",
    );

    const guySitting = PostPageItem(
      imagePath: "assets/images/chill.jpg",
      likes: "14k",
      comments: "101",
      shares: "10k",
    );

    const redFlowers = PostPageItem(
      imagePath: "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
      likes: "14k",
      comments: "101",
      shares: "10k",
    );

    const catGlasses = PostPageItem(
      imagePath: "assets/images/chill.jpg",
      likes: "14k",
      comments: "101",
      shares: "10k",
      hasBorder: true, // Blue border highlight
    );

    const pinkDaisies = PostPageItem(
      imagePath: "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
      likes: "14k",
      comments: "101",
      shares: "10k",
    );

    const blueWave = PostPageItem(
      imagePath: "assets/images/live.jpg",
      likes: "14k",
      comments: "101",
      shares: "10k",
    );

    const tarotCard = PostPageItem(
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
      likes: "14k",
      comments: "101",
      shares: "10k",
    );

    const glowingCouple = PostPageItem(
      imagePath: "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
      likes: "33k",
      comments: "15k",
      shares: "373",
    );

    const girlStairs = PostPageItem(
      imagePath: "assets/images/d68f7fe5e241018c89f66e7f3c31adf22f5f0370.jpg",
      likes: "14k",
      comments: "101",
      shares: "10k",
    );

    const redHairWoman = PostPageItem(
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
      likes: "14k",
      comments: "101",
      shares: "10k",
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(padding),
        children: [
          // Block 1: Large celestial woman (left, 2x2) + cow and guy (right, 1x1)
          SizedBox(
            height: cellWidth * 2 + spacing,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTile(celestialWoman, isLarge: true),
                ),
                const SizedBox(width: spacing),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(child: _buildTile(cow)),
                      const SizedBox(height: spacing),
                      Expanded(child: _buildTile(guySitting)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: spacing),

          // Block 2: Red flowers, Cat with blue border, Pink daisies (three 1x1 tiles)
          SizedBox(
            height: cellWidth,
            child: Row(
              children: [
                Expanded(child: _buildTile(redFlowers)),
                const SizedBox(width: spacing),
                Expanded(child: _buildTile(catGlasses)),
                const SizedBox(width: spacing),
                Expanded(child: _buildTile(pinkDaisies)),
              ],
            ),
          ),
          const SizedBox(height: spacing),

          // Block 3: Blue wave & Tarot card (left, 1x1) + Glowing couple (right, 2x2)
          SizedBox(
            height: cellWidth * 2 + spacing,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(child: _buildTile(blueWave)),
                      const SizedBox(height: spacing),
                      Expanded(child: _buildTile(tarotCard)),
                    ],
                  ),
                ),
                const SizedBox(width: spacing),
                Expanded(
                  flex: 2,
                  child: _buildTile(glowingCouple, isLarge: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: spacing),

          // Block 4: Girl stairs & Red hair woman (two 1x1 tiles)
          SizedBox(
            height: cellWidth,
            child: Row(
              children: [
                Expanded(child: _buildTile(girlStairs)),
                const SizedBox(width: spacing),
                Expanded(child: _buildTile(redHairWoman)),
                const Spacer(), // Empty space for the 3rd column since it's omitted
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(PostPageItem item, {bool isLarge = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border:
            item.hasBorder
                ? Border.all(color: const Color(0xFF0091FF), width: 2.0)
                : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(item.hasBorder ? 6.0 : 8.0),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(item.imagePath, fit: BoxFit.cover),
            ),
            // Dark gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
            ),
            // Stats Overlay (bottom-center aligned)
            Positioned(
              bottom: isLarge ? 20.0 : 10.0,
              left: 4.0,
              right: 4.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Heart (Likes)
                  Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: isLarge ? 20.0 : 13.0,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.likes,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isLarge ? 15.0 : 11.0,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Comment Bubble
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: isLarge ? 18.0 : 12.0,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.comments,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isLarge ? 15.0 : 11.0,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Paper Plane (Shares)
                  Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: isLarge ? 18.0 : 12.0,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.shares,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isLarge ? 15.0 : 11.0,
                      fontFamily: 'Inter',
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
