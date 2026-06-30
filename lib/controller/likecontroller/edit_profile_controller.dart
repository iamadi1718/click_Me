import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final name = TextEditingController();
  final username = TextEditingController();
  final dob = TextEditingController();
  final bio = TextEditingController();
  final link = TextEditingController();
  final selectedGender = RxnString();

  @override
  void onClose() {
    name.dispose();
    username.dispose();
    dob.dispose();
    bio.dispose();
    link.dispose();
    super.onClose();
  }

  void selectGender(String? value) {
    selectedGender.value = value;
  }

  void saveProfile() {
    // API logic can be added later
  }
}
