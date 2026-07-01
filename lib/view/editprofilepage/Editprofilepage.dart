import 'package:click_me/controller/likecontroller/update_profile_controller.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:click_me/view/customtextfield/CustomTextfield.dart';
import 'package:click_me/view/settingspage/Settingspage.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Editprofilepages extends GetView<UpdateProfileController> {
  const Editprofilepages({super.key});

  @override
  UpdateProfileController get controller =>
      Get.put(UpdateProfileController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.05),

                    GestureDetector(
                      onTap: () => controller.pickAvatar(),
                      child: Obx(() {
                        ImageProvider imageProvider;
                        if (controller.selectedAvatar.value != null) {
                          imageProvider = FileImage(controller.selectedAvatar.value!);
                        } else if (controller.profileImageUrl.value.isNotEmpty) {
                          final fullUrl = controller.profileImageUrl.value.startsWith('http')
                              ? controller.profileImageUrl.value
                              : "${Api.baseUrl}${controller.profileImageUrl.value}";
                          imageProvider = NetworkImage(fullUrl);
                        } else {
                          imageProvider = const AssetImage('assets/images/profile.jpg');
                        }

                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: imageProvider,
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
                        );
                      }),
                    ),
                    SizedBox(height: height * 0.05),
                    Customtextfield(
                      first: 'Name',
                      second: 'Enter name',
                      controller: controller.nameController,
                    ),
                    Customtextfield(
                      first: 'Username',
                      second: 'Enter username',
                      controller: controller.usernameController,
                      icon: const Icon(Icons.edit),
                    ),
                    Customtextfield(
                      first: 'Bio',
                      second: 'Enter bio',
                      controller: controller.bioController,
                      icon: const Icon(Icons.edit),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<String>(
                                value: controller.selectedGender.value,
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  hintText: 'Select gender',
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                                  ),
                                ),
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
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: controller.dobController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Date of birth',
                                  hintText: 'Select date',
                                  fillColor: Colors.white,
                                  filled: true,
                                  suffixIcon: const Icon(Icons.calendar_today, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                                  ),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: controller.selectedDob ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now(),
                                  );

                                  if (pickedDate != null) {
                                    controller.selectedDob = pickedDate;
                                    controller.dobController.text =
                                        '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Customtextfield(
                      first: 'Add a link',
                      second: 'Enter link',
                      controller: controller.linkController,
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
            if (controller.isLoading.value)
              Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }
}

