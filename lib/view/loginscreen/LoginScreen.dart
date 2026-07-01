import 'package:click_me/view/custombackground/Custombackground.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:click_me/view/customtextfield/CustomTextfield.dart';
import 'package:click_me/view/forgetpassword/Forgetpassword.dart';
import 'package:click_me/view/signupscreen/Signupscreen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:click_me/controller/likecontroller/login_controller.dart';

class Loginscreen extends StatelessWidget {
  Loginscreen({super.key});

  final controller = Get.put(LoginController());
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Custombackground(
        widget: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.2),
                Image.asset('assets/images/splash_logo.png'),
                SizedBox(height: height * 0.07),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
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
                  first: 'Email address',
                  second: 'XXXXXX',
                  controller: controller.email,
                ),
                Obx(
                  () => Customtextfield(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }

                      return null;
                    },
                    obscureText: controller.isPasswordHidden.value,
                    first: 'Password',
                    second: 'XXXXXX',
                    icon: IconButton(
                      onPressed: () {
                        controller.isPasswordHidden.toggle();
                      },
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    controller: controller.password,
                  ),
                ),
                Custombutton(
                  text: 'Log In',
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      controller.login();
                    }
                  },
                  buttoncolor: Color.fromRGBO(85, 13, 155, 1),
                  bordercolor: Color.fromRGBO(85, 13, 155, 1),
                  textcolor: Colors.white,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => ForgotPassword());
                  },
                  child: Text(
                    'Forgotten Password?',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                SizedBox(height: height * 0.1),
                Custombutton(
                  text: 'Create New Account',
                  onTap: () {
                    Get.to(() => Signupscreen());
                  },
                  buttoncolor: Colors.white,
                  bordercolor: Color.fromRGBO(114, 111, 220, 1),
                  textcolor: Color.fromRGBO(114, 111, 220, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
