import 'package:flutter/material.dart';
import 'package:click_me/view/custom/wallpaper.dart';

class ChatBackground extends StatelessWidget {
  final Widget child;

  const ChatBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WallpaperModel>(
      valueListenable: WallpaperManager.currentWallpaper,
      builder: (context, wallpaper, _) {
        return Container(
          decoration: BoxDecoration(
            image:
                wallpaper.imageAsset != null
                    ? DecorationImage(
                      image: AssetImage(wallpaper.imageAsset!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withValues(
                          alpha: 0.2,
                        ), // 10% visible (90% faded)
                        BlendMode.dstATop,
                      ),
                    )
                    : null,
            gradient: wallpaper.gradient,
          ),
          child: child,
        );
      },
    );
  }
}
