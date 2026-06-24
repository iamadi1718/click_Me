import 'package:click_me/view/AddStory/AddStoryCard.dart';
import 'package:click_me/view/customposts/Customposts.dart';
import 'package:click_me/view/customstory/Customstory.dart';
import 'package:flutter/material.dart';
import 'package:click_me/view/Saved%20Audio/Saved_Audio.dart';
import 'package:click_me/view/NotificationScreen/Notification.dart';
import 'package:click_me/view/Chat_QueueScreen/Chat_Queue.dart';
import 'package:click_me/view/settingspage/Settingspage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/clickME.png',
                      width: 92,
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SavedAudio(),
                          ),
                        );
                      },
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                    SizedBox(width: width * 0.35),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.notification_add,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatQueue(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.chat,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.menu,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Color.fromRGBO(222, 222, 222, 1),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10),
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search your vibe',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 0,
                  ),
                  child: Divider(thickness: 2),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Addstorycard(),
                      SizedBox(width: width * 0.05),
                      Customstory(
                        bgimage: AssetImage('assets/images/story2.jpg'),
                        text: 'Erica Greens',
                      ),
                      SizedBox(width: width * 0.05),
                      Customstory(
                        bgimage: AssetImage('assets/images/red.jpg'),
                        text: 'Olive Smith',
                      ),
                      SizedBox(width: width * 0.05),
                      Customstory(
                        bgimage: AssetImage('assets/images/story2.jpg'),
                        text: 'Erica Greens',
                      ),
                      SizedBox(width: width * 0.05),
                      Customstory(
                        bgimage: AssetImage('assets/images/red.jpg'),
                        text: 'Olive Smith',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.03),
                Customposts(
                  title: 'Erica Greens',
                  time: '5h',
                  content:
                      'Painted a little something today. Thought i’d share with u guys...\n show some love and comment your favorite flower in the comment\n <3',
                  image: AssetImage('assets/images/red.jpg'),
                  iconno: '50k+',
                  comment: '380',
                  send: '71',
                ),
                SizedBox(height: height * 0.001),
                Customposts(
                  title: 'Jack Hollow',
                  time: '11h',
                  content:
                      'finally the justice has been served... i mean no harm obviously!',
                  image: AssetImage('assets/images/red.jpg'),
                  iconno: '101k+',
                  comment: '1017',
                  send: '18k',
                ),
                SizedBox(height: height * 0.03),
                Customposts(
                  title: 'Olive Smith',
                  time: '13h',
                  content:
                      "Because women don't have to be men's equals to be considered\n contenders; they have to be better. That's the lie of it all. You have\n to be better to prove yourself worthy of being equal. Unfair!",
                  image: AssetImage('assets/images/story2.jpg'),
                  iconno: '102k+',
                  comment: '456',
                  send: '87',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
