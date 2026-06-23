import 'package:flutter/material.dart';

class ReelItem {
  final String imagePath;
  final String views;
  final String likes;

  const ReelItem({
    required this.imagePath,
    required this.views,
    required this.likes,
  });
}

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final List<ReelItem> _reelItems = [
    const ReelItem(
      imagePath: "assets/images/live.jpg",
      views: "33k",
      likes: "15k",
    ),
    const ReelItem(
      imagePath: "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
      views: "103k",
      likes: "57k",
    ),
    const ReelItem(
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
      views: "1M",
      likes: "977k",
    ),
    const ReelItem(
      imagePath: "assets/images/chill.jpg",
      views: "33k",
      likes: "15k",
    ),
    const ReelItem(
      imagePath: "assets/images/d68f7fe5e241018c89f66e7f3c31adf22f5f0370.jpg",
      views: "103k",
      likes: "57k",
    ),
    const ReelItem(
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
      views: "1M",
      likes: "977k",
    ),
    const ReelItem(
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
      views: "33k",
      likes: "15k",
    ),
    const ReelItem(
      imagePath: "assets/images/live.jpg",
      views: "103k",
      likes: "57k",
    ),
    const ReelItem(
      imagePath: "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
      views: "1M",
      likes: "977k",
    ),
    const ReelItem(
      imagePath: "assets/images/d68f7fe5e241018c89f66e7f3c31adf22f5f0370.jpg",
      views: "33k",
      likes: "15k",
    ),
    const ReelItem(
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
      views: "103k",
      likes: "57k",
    ),
    const ReelItem(
      imagePath: "assets/images/chill.jpg",
      views: "1M",
      likes: "977k",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: GridView.builder(
          itemCount: _reelItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
            childAspectRatio: 0.58,
          ),
          itemBuilder: (context, index) {
            final item = _reelItems[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(item.imagePath, fit: BoxFit.cover),
                  ),

                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_circle_outline_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.views,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.favorite_border_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.likes,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
