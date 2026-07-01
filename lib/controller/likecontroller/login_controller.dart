import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:click_me/view/dashboardpage/Dashboardpage.dart';
import 'package:click_me/data/services/repository/auth repository/login_repo.dart';
import 'package:click_me/data/services/local/storage_services.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final repository = LoginRepository();

  final email = TextEditingController();
  final password = TextEditingController();
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login() async {
    try {
      isLoading.value = true;

      // 1. Firebase Auth Sign In
      final UserCredential value = await _auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );

      // 2. Custom Backend Sign In
      final response = await repository.login(
        email: email.text.trim(),
        password: password.text,
      );

      Utils().toastmessage("Login Success: ${value.user!.email}");

      // 3. Save Tokens to Local Storage
      await StorageService.saveAccessToken(response.data.accessToken);
      await StorageService.saveRefreshToken(response.data.refreshToken);
      await StorageService.saveUserId(response.data.user.id);

      // 4. Navigate to Dashboard
      Get.to(() => Dashboardpage());
    } catch (error) {
      Utils().toastmessage(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
