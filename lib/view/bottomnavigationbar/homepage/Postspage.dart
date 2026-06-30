import 'package:click_me/Models/PostsModel/PostsModel.dart';
import 'package:click_me/services/PostsServices/PostsServices.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<PostsModel> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = PostsService().getPostsData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostsModel>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData ||
            snapshot.data!.data == null ||
            snapshot.data!.data!.posts == null ||
            snapshot.data!.data!.posts!.isEmpty) {
          return const Center(
            child: Text("No Posts"),
          );
        }

        final posts = snapshot.data!.data!.posts!;

        return GridView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return PostTile(post: posts[index]);
          },
        );
      },
    );
  }
}



class PostTile extends StatelessWidget {
  final ExplorePost post;

  const PostTile({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final media = post.media!.first;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "${Api.baseUrl}${media.thumbnail}",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.image),
              );
            },
          ),

          Container(
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

          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.favorite_border, "${post.likesCount}"),
                _iconText(Icons.mode_comment_outlined, "${post.commentsCount}"),
                _iconText(Icons.send_outlined, "${post.sharesCount}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 2),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}