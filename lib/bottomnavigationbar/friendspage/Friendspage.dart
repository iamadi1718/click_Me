import 'package:click_me/custombutton/Custombutton.dart';
import 'package:click_me/customfriends/Customfriends.dart';
import 'package:flutter/material.dart';

class Friendspage extends StatelessWidget {
  const Friendspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Friends')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'People who follow you and you follow them back are automatically\n your friends. Start new friendships with clickME...',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            Customfriends(),
            Customfriends(),
            Customfriends(),
            Customfriends(),
            Customfriends(),
            Customfriends(),
            Customfriends(),
            Customfriends(),
            Customfriends(),
            Customfriends(),
          ],
        ),
      ),
    );
  }
}
