import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedAudioItem {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final String coverPath;

  SavedAudioItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.coverPath,
  });
}

class SavedAudio extends StatefulWidget {
  const SavedAudio({super.key});

  @override
  State<SavedAudio> createState() => _SavedAudioState();
}

class _SavedAudioState extends State<SavedAudio> {
  final List<SavedAudioItem> _savedAudios = [
    SavedAudioItem(
      id: '1',
      title: 'GODS',
      artist: 'NewJeans',
      duration: '3:40',
      coverPath: 'assets/images/795f466d65c2a48f9bee7b813cd6d34468581ad3.jpg',
    ),
    SavedAudioItem(
      id: '2',
      title: 'Chill Vibes',
      artist: 'Lofi Cafe',
      duration: '2:15',
      coverPath: 'assets/images/chill.jpg',
    ),
    SavedAudioItem(
      id: '3',
      title: 'Late Night Drive',
      artist: 'Synthwave',
      duration: '4:02',
      coverPath: 'assets/images/d68f7fe5e241018c89f66e7f3c31adf22f5f0370.jpg',
    ),
  ];

  void _removeAudio(int index) {
    final removedItem = _savedAudios[index];
    setState(() {
      _savedAudios.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Removed '${removedItem.title}'",
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        action: SnackBarAction(
          label: "Undo",
          textColor: const Color(0xff550D9B),
          onPressed: () {
            setState(() {
              _savedAudios.insert(index, removedItem);
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: const Text(
          "Saved Audio",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body:
          _savedAudios.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.music_off_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No saved audio",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _savedAudios.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = _savedAudios[index];
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item.coverPath,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${item.artist} • ${item.duration}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeAudio(index),
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Color(0xFF9E9E9E),
                          size: 24,
                        ),
                      ),
                    ],
                  );
                },
              ),
    );
  }
}
