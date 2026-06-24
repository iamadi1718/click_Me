import 'package:click_me/editprofilepage/Editprofilepage.dart';
import 'package:click_me/postswidget/Postswidget.dart';
import 'package:click_me/savedwidget/Savedwidget.dart';
import 'package:flutter/material.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  int selectedtab = 0;
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profiles.jpg'),
                  radius: 40,
                ),
                SizedBox(width: width * 0.04),
                Column(
                  children: [
                    Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        _profilestat('5', 'Posts'),
                        _profilestat('250', 'Followers'),
                        _profilestat('300', 'Following'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Text(
              'Full Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              'Bio would be shown here along with\n any links that user adds ',
            ),
            TextButton(
              onPressed: () {},
              child: Text('Link', style: TextStyle(color: Colors.blueAccent)),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Editprofilepages()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Color.fromRGBO(114, 111, 220, 1),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(114, 111, 220, 1),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            CircleAvatar(radius: 26, child: Center(child: Icon(Icons.add))),
            Text('highlights'),
            Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    selectedtab = 0;
                  },
                  child: Icon(
                    Icons.grid_view,
                    size: 34,
                    color:
                        selectedtab == 0
                            ? Color.fromRGBO(85, 13, 155, 1)
                            : Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    selectedtab = 1;
                  },

                  child: Icon(
                    Icons.movie_creation_outlined,
                    size: 34,
                    color:
                        selectedtab == 1
                            ? Color.fromRGBO(85, 13, 155, 1)
                            : Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    selectedtab = 2;
                  },
                  child: Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 34,
                    color:
                        selectedtab == 2
                            ? Color.fromRGBO(85, 13, 155, 1)
                            : Colors.black,
                  ),
                ),
              ],
            ),
            Divider(thickness: 1),
            Expanded(
              child:
                  selectedtab == 0
                      ? Postswidget()
                      : selectedtab == 1
                      ? Savedwidget()
                      : Postswidget(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _profilestat(String num, String stats) {
  return Row(
    children: [
      Column(
        children: [
          Text(
            num,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          Text(
            stats,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color.fromRGBO(115, 113, 113, 1),
            ),
          ),
        ],
      ),
      SizedBox(width: 20),
    ],
  );
}
