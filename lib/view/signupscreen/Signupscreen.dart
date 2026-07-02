import 'package:click_me/view/custombackground/AuthenticationCustombackground.dart';
import 'package:click_me/view/custombackground/Custombackground.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:click_me/view/customtextfield/AuthenticationCustomTextfield.dart';
import 'package:click_me/view/customtextfield/CustomTextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:click_me/controller/likecontroller/register_controller.dart';

class Signupscreen extends StatelessWidget {
  Signupscreen({super.key});

  final controller = Get.put(RegisterController());
  final _formkey = GlobalKey<FormState>();
  final selectedGender = Rxn<String>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AuthenticationCustombackground(
        widget: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.01),
              Image.asset('assets/images/splash_logo.png', scale: 2),
              SizedBox(height: height * 0.02),
              Align(
                alignment: Alignment.center,
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
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      AuthenticationCustomtextfield(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        first: 'Full Name',
                        second: 'John Doe',
                        controller: controller.name,
                      ),
                      SizedBox(height: height * 0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            /// Gender Dropdown
                            Expanded(
                              flex: 2,
                              child: Obx(
                                () => DropdownButtonFormField<String>(
                                  value: controller.selectedGender.value,
                                  dropdownColor: const Color(0xFF3A3555),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF8D8AA8),
                                  ),
                                  hint: const Text(
                                    "Gender",
                                    style: TextStyle(color: Color(0xFF8D8AA8)),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFF3A3555),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.08),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF8B5CF6),
                                      ),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "Male",
                                      child: Text("Male"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Female",
                                      child: Text("Female"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Other",
                                      child: Text("Other"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    controller.selectedGender.value = value!;
                                  },
                                ),
                              ),
                            ),
                
                            const SizedBox(width: 12),
                
                            /// Date of Birth
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: controller.dateOfBirth,
                                readOnly: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                decoration: InputDecoration(
                                  hintText: "YYYY-MM-DD",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF8D8AA8),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFF8D8AA8),
                                    size: 20,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF3A3555),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF8B5CF6),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.dark().copyWith(
                                          colorScheme: const ColorScheme.dark(
                                            primary: Color(0xFF8B5CF6),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                
                                  if (pickedDate != null) {
                                    controller.selectedDob = pickedDate;
                                    controller.dateOfBirth.text =
                                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      AuthenticationCustomtextfield(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        first: 'Mobile Number',
                        second: '+91 8799741295',
                        controller: controller.phone,
                      ),
                      SizedBox(height: height * 0.02),
                      AuthenticationCustomtextfield(
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          color: Color(0xFF8D8AA8),
                        ),
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
                        second: 'name@example.com',
                        controller: controller.email,
                      ),
                      SizedBox(height: height * 0.02),
                      Obx(
                        () => AuthenticationCustomtextfield(
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xFF8D8AA8),
                          ),
                          controller: controller.password,
                          obscureText: controller.isPasswordHidden.value,
                          first: 'Password',
                          second: '......',
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
                              color: Color(0xFF8D8AA8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Obx(
                        () => AuthenticationCustomtextfield(
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xFF8D8AA8),
                          ),
                          controller: controller.confirmPassword,
                          obscureText: controller.isConfirmPasswordHidden.value,
                          first: 'Confirm Password',
                          second: '......',
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
                              color: Color(0xFF8D8AA8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Obx(
                        () =>
                            controller.isLoading.value
                                ? const CircularProgressIndicator()
                                : InkWell(
                                  onTap: () {
                                    if (_formkey.currentState!.validate()) {
                                      controller.register();
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
                                        "Create Account",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
