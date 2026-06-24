import 'package:click_me/custombutton/Custombutton.dart';
import 'package:flutter/material.dart';

class Customfriends extends StatelessWidget {
  const Customfriends({super.key});

  @override
  Widget build(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
    return   Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/friends.png'),
                  radius: 30,
                ),
                SizedBox(width: width * 0.03),
                Column(
                  children: [
                    Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Friends since',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(115, 113, 113, 1),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width * 0.05),
                Expanded(
                  child: Custombutton(
                    text: 'Message',
                    onTap: () {},
                    buttoncolor: Colors.deepPurple,
                    bordercolor: Colors.deepPurple,
                    textcolor: Colors.white,
                  ),
                ),
                Expanded(
                  child: Custombutton(
                    text: 'Unfriend',
                    onTap: () {},
                    buttoncolor: Colors.grey,
                    bordercolor: Colors.grey,
                    textcolor: Colors.white,
                  ),
                ),
              ],
            ),
          );
  }
}