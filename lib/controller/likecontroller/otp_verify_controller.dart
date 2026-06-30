import 'dart:async';
import 'package:click_me/controller/likecontroller/register_controller.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/data/services/repository/auth repository/otp_verify_repo.dart';
import 'package:click_me/view/addprofilepage/AddProfilepage.dart';
import 'package:click_me/view/dashboardpage/Dashboardpage.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerifyController extends GetxController {
  static OtpVerifyController get instance => Get.find();

  final repository = OtpVerifyRepository();

  final phoneOrEmail = TextEditingController();
  final otp = TextEditingController();

  final secondsRemaining = 600.obs; // 10 minutes
  final canResend = false.obs;
  final isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    secondsRemaining.value = 600;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value == 0) {
        canResend.value = true;
        _timer?.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> loginWithOtp() async {
    try {
      isLoading.value = true;

      final response = await repository.verifyOtp(
        emailOrPhone: phoneOrEmail.text.trim(),
        otp: otp.text.trim(),
      );

      Utils().toastmessage("Verification Successful!");

      // Save Tokens to Local Storage
      await StorageService.saveAccessToken(response.data.accessToken);
      await StorageService.saveRefreshToken(response.data.refreshToken);
      await StorageService.saveUserId(response.data.user.id);

      // Check destination: if we are in signup flow (RegisterController exists), go to AddProfilepage
      if (Get.isRegistered<RegisterController>()) {
        Get.offAll(() => AddProfilepage());
      } else {
        Get.offAll(() => Dashboardpage());
      }
    } catch (error) {
      Utils().toastmessage(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() {
    Utils().toastmessage("OTP Resent Successfully!");
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    phoneOrEmail.dispose();
    otp.dispose();
    super.onClose();
  }
}
