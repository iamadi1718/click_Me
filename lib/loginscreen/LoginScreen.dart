import 'package:click_me/custombackground/Custombackground.dart';
import 'package:click_me/custombutton/Custombutton.dart';
import 'package:click_me/customtextfield/CustomTextfield.dart';
import 'package:click_me/dashboardpage/Dashboardpage.dart';
import 'package:click_me/forgetpassword/Forgetpassword.dart';
import 'package:click_me/signupscreen/Signupscreen.dart';
import 'package:click_me/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final _formkey=GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool isPasswordHidden = true;
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
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }

  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }

  return null;
},
                obscureText: isPasswordHidden,
                first: 'Password',
                second: 'XXXXXX',
                icon: IconButton(
                  onPressed: () {
                    isPasswordHidden = !isPasswordHidden;
                  },
                  icon: Icon(
                    isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                controller: passwordcontroller,
              ),
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

                controller: emailcontroller,
              ),
              Custombutton(
                text: 'Log In',
                onTap: () {
                   if (_formkey.currentState!.validate()) {
                            _auth
                                .signInWithEmailAndPassword(
                                  email: emailcontroller.text.toString(),
                                  password: passwordcontroller.text.toString(),
                                )
                                .then((value) {
                                  Utils().toastmessage(
                                    value.user!.email.toString(),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Dashboardpage(),
                                    ),
                                  );
                                })
                                .onError((error, stackTrace) {
                                  Utils().toastmessage(error.toString());
                                });
                          }
                },
                buttoncolor: Color.fromRGBO(85, 13, 155, 1),
                bordercolor: Color.fromRGBO(85, 13, 155, 1),
                textcolor: Colors.white,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
                },
                child: Text(
                  'Forgotten Password?',
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
