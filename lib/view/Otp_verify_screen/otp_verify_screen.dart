import 'package:click_me/controller/likecontroller/otp_verify_controller.dart';
import 'package:click_me/view/custombackground/Custombackground.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:click_me/view/customtextfield/CustomTextfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerifyScreen extends StatelessWidget {
  OtpVerifyScreen({super.key});

  final controller = Get.put(OtpVerifyController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Custombackground(
        widget: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Arrow Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.05),

                  // Logo (Same as splash/login screens)
                  Image.asset('assets/images/splash_logo.png'),
                  SizedBox(height: height * 0.04),

                  // Title (Log in via OTP)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Log in via OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  // Mobile number or email address Field
                  Customtextfield(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter mobile number or email address';
                      }
                      return null;
                    },
                    first: 'Mobile number or email address',
                    second: 'XXXX',
                    controller: controller.phoneOrEmail,
                  ),

                  // Enter OTP Field
                  Customtextfield(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter OTP';
                      }
                      if (value.trim().length < 4 || value.trim().length > 6) {
                        return 'OTP must be 4 to 6 digits';
                      }
                      return null;
                    },
                    first: 'Enter OTP',
                    second: 'XXXX',
                    controller: controller.otp,
                    keyboardType: TextInputType.number,
                  ),

                  // Expiry & Resend Text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Obx(
                        () => RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    controller.secondsRemaining.value > 0
                                        ? 'The OTP will expire in ${controller.formatTime(controller.secondsRemaining.value)}. Click here to '
                                        : 'The OTP has expired. Click here to ',
                              ),
                              TextSpan(
                                text: 'resend',
                                style: TextStyle(
                                  color:
                                      controller.canResend.value
                                          ? const Color.fromRGBO(85, 13, 155, 1)
                                          : Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        if (controller.canResend.value) {
                                          controller.resendOtp();
                                        }
                                      },
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),

                  // Log in Button (Filled Purple Button)
                  Custombutton(
                    text: 'Log in',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        controller.loginWithOtp();
                      }
                    },
                    buttoncolor: const Color.fromRGBO(85, 13, 155, 1),
                    bordercolor: const Color.fromRGBO(85, 13, 155, 1),
                    textcolor: Colors.white,
                  ),

                  const SizedBox(height: 10),

                  // Create new Account Button (Outlined White/Transparent Button)
                  Custombutton(
                    text: 'Create new Account',
                    onTap: () {
                      Get.back();
                    },
                    buttoncolor: Colors.transparent,
                    bordercolor: Colors.white,
                    textcolor: Colors.white,
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
