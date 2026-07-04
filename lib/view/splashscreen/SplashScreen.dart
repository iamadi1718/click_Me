import 'dart:async';

import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/custombackground/Custombackground.dart';
import 'package:click_me/view/dashboardpage/Dashboardpage.dart';
import 'package:click_me/view/loginscreen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

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
      const Duration(seconds: 3),
      () {
        final token = StorageService.getAccessToken();
        if (token.isNotEmpty) {
          Get.off(() => Dashboardpage());
        } else {
          Get.off(() => Loginscreen());
        }
      },
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
              style: GoogleFonts.kufam(
                fontWeight: FontWeight.w700,
                fontSize: 34,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
