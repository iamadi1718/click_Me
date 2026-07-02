import 'package:click_me/view/custombackground/AuthenticationCustombackground.dart';

import 'package:click_me/view/customtextfield/AuthenticationCustomTextfield.dart';

import 'package:click_me/view/forgetpassword/Forgetpassword.dart';
import 'package:click_me/view/signupscreen/Signupscreen.dart';
import 'package:flutter/gestures.dart';
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
      body: AuthenticationCustombackground(
        widget: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.01),
                  Image.asset('assets/images/splash_logo.png', scale: 2),
                  
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      ' Sign in ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'Enter your credentials to access your',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text('account', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: const Color(0xFF26234A).withOpacity(0.85),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Email Field
                        

                        const SizedBox(height: 10),

                        AuthenticationCustomtextfield(
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
                          second: "name@example.com",
                          controller: controller.email,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            color: Color(0xFF8D8AA8),
                          ),
                        ),
                        Obx(
                          () => AuthenticationCustomtextfield(
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
                            second: "Enter your password",
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF8D8AA8),
                            ),
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

                        const SizedBox(height: 14),

                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => ForgotPassword());
                            },
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        InkWell(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              controller.login();
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF8E2DE2),
                                  Color(0xFFD946EF),
                                  Color(0xFFFF7A18),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF9B96B6),
                        ),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: "Create one",
                            style: const TextStyle(
                              color: Color(0xFF8B5CF6),
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => Signupscreen());
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
