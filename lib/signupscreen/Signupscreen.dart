import 'package:click_me/custombackground/Custombackground.dart';
import 'package:click_me/custombutton/Custombutton.dart';
import 'package:click_me/customtextfield/CustomTextfield.dart';
import 'package:click_me/addprofilepage/AddProfilepage.dart';
import 'package:click_me/loginscreen/LoginScreen.dart';
import 'package:click_me/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  String? selectedGender;
  final namecontroller = TextEditingController();
  final birthcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth=FirebaseAuth.instance;

  final numbercontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Custombackground(
        widget: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.1),
              Image.asset('assets/images/splash_logo.png'),
              SizedBox(height: height * 0.1),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create New Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                   Customtextfield(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                first: 'Name',
                second: 'xxxxx',
                controller: namecontroller,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Customtextfield(
                        first: 'Date of birth',
                        second: 'xxxxx',
                        controller: birthcontroller,
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedGender,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: const Text(' Gender'),
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(
                            value: 'Female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Customtextfield(
                validator: (value) {
                  if (value == null) {
                    return 'Please enter your number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                first: 'Mobile Number',
                second: 'xxxxx',
                controller: numbercontroller,
              ),
              SizedBox(height: height * 0.02),
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

                first: 'Password',
                second: 'XXXXXX',
                icon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.visibility),
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
                text: 'Sign Up',
                onTap: () {
                  if (_formkey.currentState!.validate()) {
                    _auth
                        .createUserWithEmailAndPassword(
                          email: emailcontroller.text.toString(),
                          password: passwordcontroller.text.toString(),
                        )
                        .then((value) {
                          Utils().toastmessage(value.user!.email.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Addaddresspage(),
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
              
                  ],
                )
              ),
              Row(
                children: [
                  Text('Already have an account?'),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Loginscreen()));
                  }, child: Text('Login')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
