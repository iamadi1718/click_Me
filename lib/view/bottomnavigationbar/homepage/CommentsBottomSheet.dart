import 'package:click_me/Models/GetCommentsModel/GetCommentsModel.dart';
import 'package:click_me/services/CommentLikeService/CommentLikeService.dart';
import 'package:click_me/services/CommentService/CommentService.dart';
import 'package:click_me/services/GetCommentService/GetCommentService.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:flutter/material.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  Future<GetCommentsModel>? futureComments;
  final TextEditingController commentController = TextEditingController();

  bool isLoading = false;
  @override
void initState() {
  super.initState();

  futureComments =
      GetCommentsService().getComments(widget.postId);
}

  Future<void> addComment() async {
    if (commentController.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      await CommentService().addComment(
        postId: widget.postId,
        comment: commentController.text.trim(),
      );

      commentController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Comment Added"),
        ),
      );

      commentController.clear();

setState(() {
  futureComments =
      GetCommentsService().getComments(widget.postId);
});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .65,
        child: Column(
          children: [

            const SizedBox(height: 10),

            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Comments",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            Expanded(
  child: FutureBuilder<GetCommentsModel>(
    future: futureComments,
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

      final comments = snapshot.data?.data?.comments ?? [];

      if (comments.isEmpty) {
        return const Center(
          child: Text("No Comments Yet"),
        );
      }

      return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: comment.userId?.profileImage != null
                  ? NetworkImage(
                      "${Api.baseUrl}${comment.userId!.profileImage}",
                    )
                  : null,
              child: comment.userId?.profileImage == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(
              comment.userId?.username ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(comment.text ?? ""),
            trailing: InkWell(
  onTap: () async {
    try {
      final response = await CommentLikeService().likeComment(comment.sId!);

      setState(() {
        comment.isLiked = response.data?.isLiked;
        comment.likesCount = response.data?.likesCount;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  },
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        "${comment.likesCount ?? 0}",
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(width: 4),
      Icon(
        comment.isLiked == true
            ? Icons.favorite
            : Icons.favorite_border,
        color: Colors.red,
        size: 20,
      ),
    ],
  ),
),
          );
        },
      );
    },
  ),
),

            const Divider(),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  isLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          onPressed: addComment,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
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