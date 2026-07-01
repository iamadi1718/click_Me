import 'package:click_me/controller/likecontroller/edit_profile_controller.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:click_me/view/customtextfield/CustomTextfield.dart';
import 'package:click_me/view/settingspage/Settingspage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Editprofilepages extends StatelessWidget {
  Editprofilepages({super.key});

  final controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: height * 0.05),

              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/img1.png'),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[800],
                        child: const Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.05),
              Customtextfield(
                first: 'Name',
                second: 'xxxxx',
                controller: controller.name,
              ),
              Customtextfield(
                first: 'Username',
                second: 'xxxxx',
                controller: controller.username,
                icon: const Icon(Icons.edit),
              ),
              Customtextfield(
                first: 'Bio',
                second: 'xxxxx',
                controller: controller.bio,
                icon: const Icon(Icons.edit),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedGender.value,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
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
                          controller.selectGender(value);
                        },
                      )),
                    ),

                    Expanded(
                      child: Customtextfield(
                        first: 'Date of birth',
                        second: 'xx/xx/xxxx',
                        controller: controller.dob,
                      ),
                    ),
                  ],
                ),
              ),
              Customtextfield(
                first: 'Add a link',
                second: 'xxxxx',
                controller: controller.link,
                icon: const Icon(Icons.edit),
              ),

              InkWell(
                onTap: () {
                  Get.to(() => SettingsPage());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: const Color.fromRGBO(114, 111, 220, 1),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'More Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(114, 111, 220, 1),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 120,
                  child: Custombutton(
                    text: 'Done',
                    onTap: () {
                      controller.saveProfile();
                    },
                    buttoncolor: const Color.fromRGBO(85, 13, 155, 1),
                    bordercolor: const Color.fromRGBO(85, 13, 155, 1),
                    textcolor: Colors.white,
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
