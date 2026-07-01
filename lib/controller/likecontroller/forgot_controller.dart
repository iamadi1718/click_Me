import 'package:click_me/data/services/repository/auth repository/forgot_repo.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  static ForgotController get instance => Get.find();

  final repository = ForgotRepository();

  final email = TextEditingController();
  final phone = TextEditingController();
  final isLoading = false.obs;

  Future<void> sendResetLink() async {
    try {
      isLoading.value = true;
      final emailVal = email.text.trim();

      final response = await repository.forgotPassword(email: emailVal);

      if (response.success == true) {
        final message = response.message ??
            response.data?.message ??
            'We have sent you a password reset link to your email';
        Utils().toastmessage(message);
      } else {
        Utils().toastmessage(response.message ?? 'Failed to send reset link');
      }
    } catch (error) {
      Utils().toastmessage(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    email.dispose();
    phone.dispose();
    super.onClose();
  }
}
