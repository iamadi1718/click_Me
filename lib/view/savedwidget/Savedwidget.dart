import 'package:click_me/view/models/Collections.dart';
import 'package:flutter/material.dart';

class Savedwidget extends StatefulWidget {
  const Savedwidget({super.key});

  @override
  State<Savedwidget> createState() => _SavedwidgetState();
}

class _SavedwidgetState extends State<Savedwidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
  child: GridView.builder(
    itemCount: collections.length,
    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 2.5,
    ),
    itemBuilder: (context, index) {
      final collection = collections[index];

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                collection.image,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                collection.title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
);
  }
}