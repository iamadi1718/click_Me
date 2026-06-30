import 'package:click_me/controller/likecontroller/otp_verify_controller.dart';
import 'package:click_me/data/services/network/api_exception.dart';
import 'package:click_me/data/services/repository/auth repository/auth_repo.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/Otp_verify_screen/otp_verify_screen.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  final repository = AuthRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final name = TextEditingController();
  final dateOfBirth = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final selectedGender = RxnString();
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  DateTime? selectedDob;
  final isLoading = false.obs;

  // Unified registration flow
  Future<void> register() async {
    try {
      isLoading.value = true;

      // 1. Firebase Auth Sign Up
      final firebaseUser = await registerFirebase();
      if (firebaseUser == null) return;

      // 2. Custom Backend Sign Up
      final backendSuccess = await registerUser();
      if (!backendSuccess) {
        // Rollback Firebase registration if custom backend fails
        await firebaseUser.delete();
        print("Firebase user deleted due to backend registration failure.");
        return;
      }

      Get.snackbar("Success", "Registration successful. Please verify the OTP.");

      // 3. Pre-fill OTP controller phoneOrEmail field
      if (Get.isRegistered<OtpVerifyController>()) {
        Get.find<OtpVerifyController>().phoneOrEmail.text =
            email.text.trim().isEmpty ? phone.text.trim() : email.text.trim();
      }

      // 4. Go to OTP Verify screen
      Get.to(() => OtpVerifyScreen());
    } finally {
      isLoading.value = false;
    }
  }

  // Firebase auth registration
  Future<User?> registerFirebase() async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
      return credential.user;
    } catch (e) {
      print("RegisterController Firebase Error: $e");
      Utils().toastmessage("Firebase Auth Error: $e");
      return null;
    }
  }

  // Custom backend registration
  Future<bool> registerUser() async {
    try {
      final fullName = name.text.trim();
      final nameParts = fullName.split(' ');
      final fName = nameParts.isNotEmpty ? nameParts.first : '';
      final lName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final response = await repository.register(
        firstName: fName,
        lastName: lName,
        email: email.text.trim(),
        password: password.text,
        phone: phone.text.trim(),
        gender: selectedGender.value?.toLowerCase(),
        dob: selectedDob?.toIso8601String(),
      );

      print('Token: ${response.data.accessToken}');

      // Save Token to local storage
      await StorageService.saveAccessToken(response.data.accessToken);
      await StorageService.saveRefreshToken(response.data.refreshToken);
      await StorageService.saveUserId(response.data.user.id);
      return true;
    } on ApiException catch (e) {
      print("RegisterController ApiException: ${e.message}");
      Utils().toastmessage(e.message);
      return false;
    } catch (e) {
      print("RegisterController Exception: $e");
      Utils().toastmessage(e.toString());
      return false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    dateOfBirth.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
