import 'package:flutter/material.dart';

class Addstorycard extends StatefulWidget {
  const Addstorycard({super.key});

  @override
  State<Addstorycard> createState() => _AddstorycardState();
}

class _AddstorycardState extends State<Addstorycard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 196,
      width: 112,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top section
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),

          // Plus button
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.green.shade900,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ),

          // Text
          const Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Add Story',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
