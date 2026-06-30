import 'package:flutter/material.dart';

class Customstory extends StatefulWidget {
  const Customstory({
    super.key,
    required this.bgimage,
    required this.text,
    required this.profileImage,
    this.onTap,
  });

  final ImageProvider bgimage;
  final String text;
  final ImageProvider profileImage;
  final VoidCallback? onTap;

  @override
  State<Customstory> createState() => _CustomstoryState();
}

class _CustomstoryState extends State<Customstory> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            width: 112,
            height: 196,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: widget.bgimage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: widget.profileImage,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
