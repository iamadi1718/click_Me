import 'package:click_me/Models/reel_model/ReelModel.dart';
import 'package:click_me/services/ReelsServices/ReelsServices.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';

class ReelsScreen extends StatefulWidget { const ReelsScreen({super.key}); @override State<ReelsScreen> createState() => _ReelsScreenState(); }
class _ReelsScreenState extends State<ReelsScreen> {
  late Future<ReelsModel> futureReels;

  @override
  void initState() {
    super.initState();
    futureReels = Reelsservices().getReelsData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReelsModel>(
      future: futureReels,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.data == null ||
            snapshot.data!.data!.reels == null ||
            snapshot.data!.data!.reels!.isEmpty) {
          return const Center(
            child: Text("No Reels Found"),
          );
        }

        final reels = snapshot.data!.data!.reels!;

        return GridView.builder(
          
          itemCount: reels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            return ReelTile(reel: reels[index]);
          },
        );
      },
    );
  }
}
class ReelTile extends StatelessWidget {
  final Reel reel;

  const ReelTile({
    super.key,
    required this.reel,
  });

  String formatCount(int? count) {
    if (count == null) return "0";

    if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(1)}M";
    }

    if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}K";
    }

    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [

          /// Thumbnail
          Image.network(
            "${Api.baseUrl}${reel.media?.thumbnail}",
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.video_library,
                  size: 40,
                ),
              );
            },
          ),

          /// Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black54,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// Views & Likes
          Positioned(
            left: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      formatCount(reel.viewsCount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      formatCount(reel.likesCount),
                      style: const TextStyle(
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
        ],
      ),
    );
  }
}
