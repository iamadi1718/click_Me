import 'package:click_me/Models/ExplorePostsModel/ExplorePostsModel.dart';
import 'package:click_me/services/ExplorePostsServices/ExplorePostsServices.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:flutter/material.dart';

class ExplorePostsScreen extends StatefulWidget {
  const ExplorePostsScreen({super.key});

  @override
  State<ExplorePostsScreen> createState() => _ExplorePostsScreenState();
}

class _ExplorePostsScreenState extends State<ExplorePostsScreen> {
  late Future<ExplorePostsModel> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = ExplorePostsServices().getFollowersData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExplorePostsModel>(
      future: futurePosts,
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
            snapshot.data!.data!.posts == null ||
            snapshot.data!.data!.posts!.isEmpty) {
          return const Center(
            child: Text("No Posts Found"),
          );
        }

        final posts = snapshot.data!.data!.posts!;

        return GridView.builder(
          padding: const EdgeInsets.all(2),
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return ExplorePostTile(post: posts[index]);
          },
        );
      },
    );
  }
}
class ExplorePostTile extends StatelessWidget {
  final Post post;

  const ExplorePostTile({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    if (post.media == null || post.media!.isEmpty) {
      return Container(color: Colors.grey.shade300);
    }

    final image = post.media!.first;

    return GestureDetector(
      onTap: () {
        // Open post details screen
      },
      child: Stack(
        fit: StackFit.expand,
        children: [

          Image.network(
            "${Api.baseUrl}${image.thumbnail}",
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.image),
              );
            },
          ),

          /// Multiple Images Icon
          if (post.media!.length > 1)
            const Positioned(
              top: 6,
              right: 6,
              child: Icon(
                Icons.collections,
                color: Colors.white,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}