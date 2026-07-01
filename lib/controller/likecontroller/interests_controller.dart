import 'package:click_me/controller/likecontroller/addprofile_controller.dart';
import 'package:click_me/view/dashboardpage/Dashboardpage.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:get/get.dart';

class InterestsController extends GetxController {
  static InterestsController get instance => Get.find();

  final List<Map<String, String>> interests = [
    {'emoji': '🧑‍🎤', 'title': 'Fashion'},
    {'emoji': '🍜', 'title': 'Food'},
    {'emoji': '💥', 'title': 'Pop culture'},
    {'emoji': '🎶', 'title': 'Musicals'},
    {'emoji': '📚', 'title': 'Reading'},
    {'emoji': '📷', 'title': 'Vlogging'},
    {'emoji': '🏃', 'title': 'Adventure'},
    {'emoji': '🏔️', 'title': 'Nature'},
    {'emoji': '💃', 'title': 'Dance'},
    {'emoji': '🚗', 'title': 'Automobile'},
    {'emoji': '🏆', 'title': 'E-sports'},
    {'emoji': '📦', 'title': 'Other'},
  ];

  final selectedInterests = <String>[].obs;
  final isLoading = false.obs;

  void toggleInterest(String title) {
    if (selectedInterests.contains(title)) {
      selectedInterests.remove(title);
    } else {
      selectedInterests.add(title);
    }
  }

  Future<void> saveInterests() async {
    if (selectedInterests.isEmpty) {
      Utils().toastmessage("Please select at least one interest");
      return;
    }

    try {
      isLoading.value = true;

      // 1. Submit complete profile if profile setup was active
      if (Get.isRegistered<AddProfileController>()) {
        final profileController = Get.find<AddProfileController>();
        final profileSuccess = await profileController.completeProfileOnServer();
        if (!profileSuccess) {
          isLoading.value = false;
          return;
        }
      }

      // 2. Complete and save interests
      Utils().toastmessage("Profile set up completed successfully!");
      
      // 3. Redirect to Dashboard
      Get.offAll(() => Dashboardpage());
    } catch (e) {
      Utils().toastmessage("Setup failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void skip() {
    Get.offAll(() => Dashboardpage());
  }
}
