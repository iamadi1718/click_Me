import 'package:flutter/material.dart';

class Customposts extends StatefulWidget {
  const Customposts({
    super.key,
    required this.title,
    required this.time,
    required this.content,
    required this.image,
    required this.iconno,
    required this.comment,
    required this.send,
  });
  final String title;
  final String time;
  final String content;
  final ImageProvider image;
  final String iconno;
  final String comment;
  final String send;

  @override
  State<Customposts> createState() => _CustompostsState();
}

class _CustompostsState extends State<Customposts> {
  bool favourite = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: const Divider(thickness: 1, color: Colors.grey),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              SizedBox(width: width * 0.02),
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

                  Text(widget.time),
                ],
              ),
              SizedBox(width: width * 0.48),
              const Icon(Icons.more_vert, size: 34),
            ],
          ),
          SizedBox(height: height * 0.02),
          Text(
            widget.content,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: height * 0.01),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(20),
              image: DecorationImage(image: widget.image, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: height * 0.02),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  favourite = true;
                },
                icon:
                    favourite
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border),
              ),
              Text(
                widget.iconno,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(width: width * 0.01),
              IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
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
      ),
    );
  }
}
