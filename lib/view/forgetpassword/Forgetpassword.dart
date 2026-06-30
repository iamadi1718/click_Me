import 'package:click_me/controller/likecontroller/forgot_controller.dart';
import 'package:click_me/view/custombackground/Custombackground.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:click_me/view/customtextfield/CustomTextfield.dart';
import 'package:click_me/view/loginscreen/LoginScreen.dart';
import 'package:click_me/view/signupscreen/Signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final controller = Get.put(ForgotController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Custombackground(
        widget: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.2),
                Image.asset('assets/images/splash_logo.png'),
                SizedBox(height: height * 0.07),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Login Via OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Customtextfield(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  first: 'Enter email',
                  second: 'XXXXXX',
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.email,
                ),
                Customtextfield(
                  first: 'Email phone',
                  second: 'XXXXXX',
                  controller: controller.phone,
                  keyboardType: const TextInputType.numberWithOptions(),
                ),
                Custombutton(
                  text: 'Reset Link',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.sendResetLink();
                    }
                  },
                  buttoncolor: const Color.fromRGBO(85, 13, 155, 1),
                  bordercolor: const Color.fromRGBO(85, 13, 155, 1),
                  textcolor: Colors.white,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => Loginscreen());
                  },
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                SizedBox(height: height * 0.1),
                Custombutton(
                  text: 'Create New Account',
                  onTap: () {
                    Get.to(() => Signupscreen());
                  },
                  buttoncolor: Colors.white,
                  bordercolor: const Color.fromRGBO(114, 111, 220, 1),
                  textcolor: const Color.fromRGBO(114, 111, 220, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
