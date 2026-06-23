import 'package:flutter/material.dart';

class WallpaperModel {
  final String name;
  final String? imageAsset;
  final LinearGradient? gradient;

  const WallpaperModel({required this.name, this.imageAsset, this.gradient});
}

class WallpaperManager {
  static const List<WallpaperModel> wallpapers = [
    WallpaperModel(name: "wallpaper1", imageAsset: "assets/images/chat_bg.png"),
    WallpaperModel(
      name: "wallpaper2",
      gradient: LinearGradient(
        colors: [Color(0xFF6F2DBD), Color(0xFFFFDA7B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    WallpaperModel(
      name: "wallpaper3",
      gradient: LinearGradient(
        colors: [Color(0xFF43C6AC), Color(0xFF191654)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    WallpaperModel(
      name: "wallpaper4",
      gradient: LinearGradient(
        colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  // Default is wallpaper 1 (doodle background)
  static final ValueNotifier<WallpaperModel> currentWallpaper =
      ValueNotifier<WallpaperModel>(wallpapers[0]);

  static void changeWallpaper(WallpaperModel wallpaper) {
    currentWallpaper.value = wallpaper;
  }
}

class WallpaperDialog extends StatelessWidget {
  const WallpaperDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Wallpaper",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children:
                  WallpaperManager.wallpapers.map((wallpaper) {
                    return InkWell(
                      onTap: () {
                        WallpaperManager.changeWallpaper(wallpaper);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 8.0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                                image:
                                    wallpaper.imageAsset != null
                                        ? DecorationImage(
                                          image: AssetImage(
                                            wallpaper.imageAsset!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                        : null,
                                gradient: wallpaper.gradient,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              wallpaper.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
