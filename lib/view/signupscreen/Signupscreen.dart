import 'package:click_me/view/custombackground/Custombackground.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:click_me/view/customtextfield/CustomTextfield.dart';
import 'package:click_me/view/loginscreen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/controller/likecontroller/register_controller.dart';

class Signupscreen extends StatelessWidget {
  Signupscreen({super.key});

  final controller = Get.put(RegisterController());
  final _formkey = GlobalKey<FormState>();

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
                child: const Text(
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
                      controller: controller.name,
                    ),
                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.dateOfBirth,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Date of Birth',
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: const Icon(Icons.calendar_today),
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
                                  controller.selectedDob = pickedDate;
                                  controller.dateOfBirth.text =
                                      '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(
                              () => DropdownButtonFormField<String>(
                                value: controller.selectedGender.value,
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
                                  controller.selectedGender.value = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    Customtextfield(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      first: 'Mobile Number',
                      second: 'xxxxx',
                      controller: controller.phone,
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
                      controller: controller.email,
                    ),
                    SizedBox(height: height * 0.02),
                    Obx(
                      () => Customtextfield(
                        controller: controller.password,
                        obscureText: controller.isPasswordHidden.value,
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
                            controller.isPasswordHidden.toggle();
                          },
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Obx(
                      () => Customtextfield(
                        controller: controller.confirmPassword,
                        obscureText: controller.isConfirmPasswordHidden.value,
                        first: 'Confirm Password',
                        second: 'XXXXXX',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please retype your password';
                          }
                          if (value != controller.password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        icon: IconButton(
                          onPressed: () {
                            controller.isConfirmPasswordHidden.toggle();
                          },
                          icon: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Obx(
                      () => controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : Custombutton(
                              text: 'Sign Up',
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  controller.register();
                                }
                              },
                              buttoncolor: const Color.fromRGBO(85, 13, 155, 1),
                              bordercolor: const Color.fromRGBO(85, 13, 155, 1),
                              textcolor: Colors.white,
                            ),
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
                        Get.off(() => Loginscreen());
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
