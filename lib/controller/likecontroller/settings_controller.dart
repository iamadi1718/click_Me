import 'package:get/get.dart';

class SettingsController extends GetxController {
  final isDark = false.obs;

  void toggleTheme(bool value) {
    isDark.value = value;
  }
}
