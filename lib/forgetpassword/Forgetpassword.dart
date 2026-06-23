import 'package:click_me/custombackground/Custombackground.dart';
import 'package:click_me/custombutton/Custombutton.dart';
import 'package:click_me/customtextfield/CustomTextfield.dart';
import 'package:click_me/loginscreen/LoginScreen.dart';
import 'package:click_me/signupscreen/Signupscreen.dart';
import 'package:click_me/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailcontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  @override
  
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Custombackground(
        widget: SingleChildScrollView(
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
                  'Login Via OTP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Customtextfield(
                first: 'Enter email',
                second: 'XXXXXX',
                keyboardType: TextInputType.emailAddress,

                controller: emailcontroller,
              ),
              Customtextfield(
                first: 'Email phone',
                second: 'XXXXXX',

                controller: emailcontroller,
                keyboardType: TextInputType.numberWithOptions(),
              ),
              Custombutton(
                text: 'Reset Link',
                onTap: () {
                   _auth
                        .sendPasswordResetEmail(
                          email: emailcontroller.text.toString(),
                        )
                        .then((value) {
                          Utils().toastmessage(
                            'We have sent you an password to check email',
                          );
                        })
                        .onError((error, stackTrace) {
                          Utils().toastmessage(error.toString());
                        });
                },
                buttoncolor: Color.fromRGBO(85, 13, 155, 1),
                bordercolor: Color.fromRGBO(85, 13, 155, 1),
                textcolor: Colors.white,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Loginscreen()));
                },
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(height: height * 0.1),
              Custombutton(
                text: 'Create New Account',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signupscreen()),
                  );
                },
                buttoncolor: Colors.white,
                bordercolor: Color.fromRGBO(114, 111, 220, 1),
                textcolor: Color.fromRGBO(114, 111, 220, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
