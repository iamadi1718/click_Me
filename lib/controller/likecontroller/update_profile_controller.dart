import 'dart:io';
import 'package:click_me/controller/likecontroller/profile_controller.dart';
import 'package:click_me/services/update_profile_services/update_profile_services.dart';
import 'package:click_me/Models/update_profile_model/update_profile_model.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final dobController = TextEditingController();
  final linkController = TextEditingController();

  final selectedGender = RxnString();
  final isLoading = false.obs;
  
  // Reactive file for avatar image selection
  final selectedAvatar = Rxn<File>();
  final profileImageUrl = "".obs;
  DateTime? selectedDob;

  final _service = UpdateProfileService();
  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _prefillFields();
  }

  void _prefillFields() {
    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>().rxProfile.value?.data;
      if (profile != null) {
        final fullName = "${profile.firstName ?? ""} ${profile.lastName ?? ""}".trim();
        nameController.text = fullName;
        usernameController.text = profile.username ?? "";
        bioController.text = profile.bio ?? "";
        profileImageUrl.value = profile.profileImage ?? "";
        
        // Prefill gender (normalize value to 'Male', 'Female', 'Other')
        if (profile.gender != null && profile.gender!.isNotEmpty) {
          final g = profile.gender!.toLowerCase();
          if (g == 'male') {
            selectedGender.value = 'Male';
          } else if (g == 'female') {
            selectedGender.value = 'Female';
          } else {
            selectedGender.value = 'Other';
          }
        }

        // Prefill date of birth
        if (profile.dob != null && profile.dob!.isNotEmpty) {
          final parsedDate = DateTime.tryParse(profile.dob!);
          if (parsedDate != null) {
            selectedDob = parsedDate;
            dobController.text = "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
          }
        }
      }
    }
  }

  /// Trigger Image Picker to pick avatar photo from Gallery
  Future<void> pickAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        selectedAvatar.value = File(image.path);
      }
    } catch (e) {
      Utils().toastmessage("Error picking image: $e");
    }
  }

  void selectGender(String? value) {
    selectedGender.value = value;
  }

  Future<void> saveProfile() async {
    try {
      isLoading.value = true;

      // Extract first name and last name from name field
      final fullName = nameController.text.trim();
      String firstName = fullName;
      String lastName = "";
      if (fullName.contains(" ")) {
        final parts = fullName.split(" ");
        firstName = parts.first;
        lastName = parts.sublist(1).join(" ");
      }

      // Convert selected date of birth to ISO-8601 string if present
      String? dobIso;
      if (selectedDob != null) {
        dobIso = selectedDob!.toIso8601String();
      } else if (dobController.text.isNotEmpty) {
        try {
          final parts = dobController.text.split('/');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            dobIso = DateTime(year, month, day).toIso8601String();
          }
        } catch (_) {}
      }

      UpdateProfileModel result = await _service.updateProfile(
        firstName: firstName,
        lastName: lastName,
        username: usernameController.text.trim(),
        bio: bioController.text.trim(),
        gender: selectedGender.value?.toLowerCase(),
        dob: dobIso,
        avatarFile: selectedAvatar.value, // Pass picked file
      );

      if (result.success == true) {
        Utils().toastmessage("Profile updated successfully!");
        
        // Refresh the profile data inside home ProfileController
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchProfile();
        }
        Get.back(); // Return to profile page
      } else {
        Utils().toastmessage(result.message ?? "Failed to update profile.");
      }
    } catch (e) {
      Utils().toastmessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    dobController.dispose();
    linkController.dispose();
    super.onClose();
  }
}
