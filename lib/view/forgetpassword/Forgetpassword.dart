import 'package:click_me/controller/likecontroller/forgot_controller.dart';
import 'package:click_me/view/custombackground/AuthenticationCustombackground.dart';
 
import 'package:click_me/view/customtextfield/AuthenticationCustomTextfield.dart';
 
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final controller = Get.put(ForgotController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AuthenticationCustombackground(
        widget: Container(
           margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 50),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: const Color(0xFF26234A).withOpacity(0.85),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                Image.asset('assets/images/splash_logo.png', scale: 2),
                SizedBox(height: height * 0.02),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text('Recover access to your account',style: TextStyle(color: Colors.grey),),
                SizedBox(height: height * 0.03),
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
                  first: 'Enter email',
                  second: 'XXXXXX',
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.email,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.sendResetLink();
                    }
                  },
                  child: Container(
                     
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(14),),
                    child: const Center(
                      child: Text(
                        "Send Reset Link",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:height*0.02,),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back,color:Colors.blue),
                      SizedBox(width:width*0.02,),
                      const Text(
                        'Back to Login',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
