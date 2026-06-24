import 'dart:async';

import 'package:click_me/custombackground/Custombackground.dart';
import 'package:click_me/loginscreen/LoginScreen.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Custombackground(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash_logo.png'),
            SizedBox(height: height * 0.05),
            Text(
              'Welcome to clickME!',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 34),
            ),
          ],
        ),
      ),
    );
  }
}
