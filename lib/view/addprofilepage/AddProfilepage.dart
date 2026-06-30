import 'package:click_me/controller/likecontroller/addprofile_controller.dart';
import 'package:click_me/view/custombackground/Custombackground.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:click_me/view/customtextfield/CustomTextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProfilepage extends StatelessWidget {
  AddProfilepage({super.key});

  final controller = Get.put(AddProfileController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Custombackground(
        widget: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: height * 0.1),
                const Text(
                  'Set Up your profile',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(85, 13, 155, 1),
                  ),
                ),
                SizedBox(height: height * 0.05),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[600],
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey[800],
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05),
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
                Customtextfield(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  first: 'Username',
                  second: 'xxxxx',
                  controller: controller.username,
                  icon: const Icon(Icons.edit),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.selectedGender.value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectDate(context),
                          child: AbsorbPointer(
                            child: Customtextfield(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              first: 'Date of birth',
                              second: 'xx/xx/xxxx',
                              controller: controller.dob,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () =>
                      controller.isLoading.value
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(85, 13, 155, 1),
                            ),
                          )
                          : Custombutton(
                            text: 'Next',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                controller.completeProfile();
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
        ),
      ),
    );
  }
}
