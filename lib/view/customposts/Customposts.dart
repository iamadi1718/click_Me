import 'package:click_me/controller/likecontroller/Likecontroller.dart';
import 'package:click_me/view/utils/Time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Customposts extends StatefulWidget {
  const Customposts({
    super.key,
    required this.title,
    required this.time,

    required this.image,
    required this.iconno,
    required this.comment,
    required this.send,
    required this.index, required this.onComment, required this.postId,
  });
  final String title;
  final String time;
  final VoidCallback onComment;

  final ImageProvider image;
  final String iconno;
  final String comment;
  final String send;
  final int index;
  final String postId;

  @override
  State<Customposts> createState() => _CustompostsState();
}

class _CustompostsState extends State<Customposts> {
  late final LikeController controller;
  bool favourite = false;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<LikeController>()
        ? Get.find<LikeController>()
        : Get.put(LikeController());
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: const Divider(thickness: 1, color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                SizedBox(width: width * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.blue, size: 15),
                      ],
                    ),

                    Text(getTimeAgo(widget.time)),
                  ],
                ),
              ],
            ),

            InkWell(onTap: () {}, child: const Icon(Icons.more_vert, size: 34)),
          ],
        ),
        SizedBox(height: height * 0.02),

        SizedBox(height: height * 0.01),
        SizedBox(
          width: double.infinity,
          height: 270,
          child: Image(image: widget.image, fit: BoxFit.cover),
        ),
        SizedBox(height: height * 0.02),
        Row(
          children: [
           Obx(
  () => IconButton(
    onPressed: () {
      controller.toggleLike(widget.index);
    },
    icon: Icon(
      controller.isLiked[widget.index] == true
          ? Icons.favorite
          : Icons.favorite_border,
      color: controller.isLiked[widget.index] == true
          ? Colors.red
          : Colors.black,
    ),
  ),
),

Obx(
  () => Text(
    controller.likes[widget.index].toString(),
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  ),
),
            SizedBox(width: width * 0.01),
            IconButton(onPressed: widget.onComment,
icon: Icon(Icons.comment)),
            Text(
              widget.comment,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(width: width * 0.01),
            IconButton(onPressed: () {}, icon: Icon(Icons.send)),
            Text(
              widget.send,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
