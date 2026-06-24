import 'package:click_me/custombutton/Custombutton.dart';
import 'package:click_me/bottomnavigationbar/homepage/Homepage.dart';
import 'package:click_me/dashboardpage/Dashboardpage.dart';
import 'package:flutter/material.dart';

class Interestspage extends StatefulWidget {
  const Interestspage({super.key});

  @override
  State<Interestspage> createState() => _InterestspageState();
}

class _InterestspageState extends State<Interestspage> {
  final List<Map<String, String>> interests = [
    {'emoji': '🧑‍🎤', 'title': 'Fashion'},
    {'emoji': '🍜', 'title': 'Food'},
    {'emoji': '💥', 'title': 'Pop culture'},
    {'emoji': '🎶', 'title': 'Musicals'},
    {'emoji': '📚', 'title': 'Reading'},
    {'emoji': '📷', 'title': 'Vlogging'},
    {'emoji': '🏃', 'title': 'Adventure'},
    {'emoji': '🏔️', 'title': 'Nature'},
    {'emoji': '💃', 'title': 'Dance'},
    {'emoji': '🚗', 'title': 'Automobile'},
    {'emoji': '🏆', 'title': 'E-sports'},
    {'emoji': '📦', 'title': 'Other'},
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.1),
            Text(
              'Tell us what you like!',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: interests.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.4,
                ),
                itemBuilder: (context, index) {
                  final item = interests[index];

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Text(
                          item['emoji']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.1),
            Row(
              children: [
                SizedBox(width: width * 0.3),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Skip for Now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Custombutton(
                    text: 'Done',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboardpage(),
                        ),
                      );
                    },
                    buttoncolor: Color.fromRGBO(85, 13, 155, 1),
                    bordercolor: Color.fromRGBO(85, 13, 155, 1),
                    textcolor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
