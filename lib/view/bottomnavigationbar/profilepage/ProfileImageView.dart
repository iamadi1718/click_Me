import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileImageView extends StatelessWidget {
  final String imageUrl;

  const ProfileImageView({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: [

          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 15,
                sigmaY: 15,
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            color: Colors.black.withOpacity(.35),
          ),

          Center(
            child: Hero(
              tag: imageUrl,
              child: CircleAvatar(
                radius: 140,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),

          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),

        //   Positioned(
        //     bottom: 80,
        //     right: 25,
        //     child: CircleAvatar(
        //       radius: 24,
        //       backgroundColor: Colors.white,
        //       child: IconButton(
        //         onPressed: () {
        //           // Edit Profile Picture
        //         },
        //         icon: const Icon(
        //           Icons.edit,
        //           color: Colors.black,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ],),
    );
  }
}