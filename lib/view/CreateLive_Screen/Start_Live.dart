import 'package:flutter/material.dart';

class StartLiveScreen extends StatelessWidget {
  const StartLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(
      0xFF4C1D95,
    ); // Deep premium purple matching the screenshot

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
                    // Background Image
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Dark semi-transparent overlay for contrast
                    Positioned.fill(
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                    // Header Overlay (Back Button + Title)
                    Positioned(
                      top: 16,
                      left: 8,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
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
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeColor,
                    ),
                    child: const Center(child: FilterIcon()),
                  ),
                  // Center button: Go Live play button
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: themeColor, width: 3),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: themeColor,
                        size: 40,
                      ),
                    ),
                  ),
                  // Right button: Co-host icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
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
