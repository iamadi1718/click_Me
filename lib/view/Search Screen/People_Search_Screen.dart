import 'package:flutter/material.dart';

class PeopleItem {
  final String name;
  final String imagePath;

  const PeopleItem({required this.name, required this.imagePath});
}

class PeopleScreen extends StatelessWidget {
  final String searchQuery;

  const PeopleScreen({super.key, required this.searchQuery});

  static const List<PeopleItem> _peopleList = [
    PeopleItem(
      name: "Word",
      imagePath: "assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg",
    ),
    PeopleItem(
      name: "Word_word",
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
    ),
    PeopleItem(
      name: "worrrd",
      imagePath: "assets/images/d68f7fe5e241018c89f66e7f3c31adf22f5f0370.jpg",
    ),
    PeopleItem(name: "wooord", imagePath: "assets/images/chill.jpg"),
    PeopleItem(
      name: "wordddd",
      imagePath: "assets/images/cc6d85fb0ebb0b4e9e7af266f103ae3421c66c1a.jpg",
    ),
    PeopleItem(name: "word_in", imagePath: "assets/images/live.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList =
        _peopleList.where((person) {
          if (searchQuery.isEmpty) return true;
          return person.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No people found for '$searchQuery'",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final person = filteredList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(person.imagePath),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  person.name,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
