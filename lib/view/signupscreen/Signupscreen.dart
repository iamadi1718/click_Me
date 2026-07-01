import 'package:click_me/view/custombackground/Custombackground.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:click_me/view/customtextfield/CustomTextfield.dart';
import 'package:click_me/view/addprofilepage/AddProfilepage.dart';
import 'package:click_me/view/loginscreen/LoginScreen.dart';
import 'package:click_me/view/utils/Utils.dart';
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
  final datecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final numbercontroller = TextEditingController();
  bool isPasswordHidden = false;
  bool isConfirmPasswordHidden = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: datecontroller,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Date of Birth',
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                );

                                if (pickedDate != null) {
                                  datecontroller.text =
                                      '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                }
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedGender,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              hint: const Text('Gender'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Male',
                                  child: Text('Male'),
                                ),
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
                    SizedBox(height: height * 0.04),
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

                    SizedBox(height: height * 0.02),
                    Customtextfield(
                      controller: passwordcontroller,
                      obscureText: isPasswordHidden,
                      first: 'Password',
                      second: 'XXXXXX',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                      icon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Customtextfield(
                      controller: confirmpasswordcontroller,
                      obscureText: isConfirmPasswordHidden,
                      first: 'Confirm Password',
                      second: 'XXXXXX',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please retype your password';
                        }

                        if (value != passwordcontroller.text) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                      icon: IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordHidden = !isConfirmPasswordHidden;
                          });
                        },
                        icon: Icon(
                          isConfirmPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
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
                                Utils().toastmessage(
                                  value.user!.email.toString(),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
<<<<<<< Updated upstream:lib/view/signupscreen/Signupscreen.dart
                                    builder:
                                        (context) => const AddProfilepage(),
=======
                                    builder: (context) => AddProfilepage(),
>>>>>>> Stashed changes:lib/signupscreen/Signupscreen.dart
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
                ),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Loginscreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
