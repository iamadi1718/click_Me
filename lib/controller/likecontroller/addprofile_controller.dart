import 'package:click_me/controller/likecontroller/register_controller.dart';
import 'package:click_me/controller/likecontroller/interests_controller.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/data/services/repository/auth repository/addprofile_repo.dart';
import 'package:click_me/view/interestspage/Interestspage.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProfileController extends GetxController {
  static AddProfileController get instance => Get.find();

  final repository = AddProfileRepository();

  final name = TextEditingController();
  final username = TextEditingController();
  final dob = TextEditingController();

  final selectedGender = RxnString();
  final isLoading = false.obs;
  DateTime? selectedDob;

  @override
  void onInit() {
    super.onInit();
    // Prefill from RegisterController if it is registered
    if (Get.isRegistered<RegisterController>()) {
      final regController = Get.find<RegisterController>();
      name.text = regController.name.text;
      dob.text = regController.dateOfBirth.text;
      selectedGender.value = regController.selectedGender.value;
      selectedDob = regController.selectedDob;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDob ?? DateTime.now().subtract(
        const Duration(days: 365 * 18),
      ), // default 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      selectedDob = pickedDate;
      dob.text =
          '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
    }
  }

  // Defer actual server submission. Just validate and proceed.
  void completeProfile() {
    final nameVal = name.text.trim();
    final usernameVal = username.text.trim();
    final genderVal = selectedGender.value ?? "";
    final dobVal = dob.text.trim();

    if (nameVal.isEmpty ||
        usernameVal.isEmpty ||
        genderVal.isEmpty ||
        dobVal.isEmpty) {
      Utils().toastmessage("Please fill all details");
      return;
    }

    // Go to next page
    Get.to(() => Interestspage());
  }

  // Actual server submission when onboarding is finished
  Future<bool> completeProfileOnServer() async {
    try {
      final nameVal = name.text.trim();
      final usernameVal = username.text.trim();
      final genderVal = selectedGender.value ?? "";
      final dobVal = dob.text.trim();

      final nameParts = nameVal.split(' ');
      final fName = nameParts.isNotEmpty ? nameParts.first : '';
      final lName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      String dobIso = "";
      if (selectedDob != null) {
        dobIso = selectedDob!.toIso8601String();
      } else if (dobVal.isNotEmpty) {
        try {
          final parts = dobVal.split('/');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            dobIso = DateTime(year, month, day).toIso8601String();
          }
        } catch (_) {}
      }

      List<String> interestsList = [];
      if (Get.isRegistered<InterestsController>()) {
        interestsList = Get.find<InterestsController>().selectedInterests;
      }

      final response = await repository.completeProfile(
        firstName: fName,
        lastName: lName,
        name: nameVal,
        username: usernameVal,
        gender: genderVal.toLowerCase(),
        dob: dobIso,
        interests: interestsList,
      );



      print("AddProfileController Server Complete Response: $response");

      // Dynamically save new tokens if returned by complete-profile API
      if (response != null) {
        String? newAccessToken;
        String? newRefreshToken;
        String? newUserId;

        if (response['data'] != null) {
          final data = response['data'];
          if (data is Map) {
            newAccessToken = data['accessToken']?.toString();
            newRefreshToken = data['refreshToken']?.toString();
            newUserId = data['user']?['_id']?.toString() ?? data['user']?['id']?.toString() ?? data['userId']?.toString();
          }
        } else {
          newAccessToken = response['accessToken']?.toString();
          newRefreshToken = response['refreshToken']?.toString();
          newUserId = response['userId']?.toString();
        }

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await StorageService.saveAccessToken(newAccessToken);
          print("Saved new access token from complete-profile response.");
        }
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await StorageService.saveRefreshToken(newRefreshToken);
        }
        if (newUserId != null && newUserId.isNotEmpty) {
          await StorageService.saveUserId(newUserId);
        }
      }
      return true;
    } catch (e) {
      print("AddProfileController API Error: $e");
      Utils().toastmessage("Profile Update Error: $e");
      return false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    username.dispose();
    dob.dispose();
    super.onClose();
  }
}
