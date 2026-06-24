import 'package:flutter/material.dart';

class Customstory extends StatefulWidget {
  const Customstory({super.key, required this.bgimage, required this.text});
  final ImageProvider bgimage;
  final String text;

  @override
  State<Customstory> createState() => _CustomstoryState();
}

class _CustomstoryState extends State<Customstory> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 112,
          height: 196,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
              image: widget.bgimage,
              fit: BoxFit.cover,
              // opacity: 0.6,
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
