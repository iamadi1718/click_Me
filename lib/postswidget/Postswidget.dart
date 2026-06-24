import 'package:flutter/material.dart';

class Postswidget extends StatefulWidget {
  const Postswidget({super.key});

  @override
  State<Postswidget> createState() => _PostswidgetState();
}

class _PostswidgetState extends State<Postswidget> {
  final List<String> images = [
  'assets/images/img1.png',
  'assets/images/img2.png',
  'assets/images/img3.png',
  'assets/images/img4.png',
  'assets/images/img5.png',
];
  @override
  Widget build(BuildContext context) {
    return Expanded(
  child: GridView.builder(
    padding: EdgeInsets.zero,
    itemCount: images.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      return Image.asset(
        images[index],
        fit: BoxFit.cover,
      );
    },
  ),
);
  }
}