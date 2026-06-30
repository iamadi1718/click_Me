import 'dart:async';
import 'package:click_me/services/Storyservices/Storyservices.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:get/get.dart';

class StoryViewController extends GetxController {
  final progress = 0.0.obs;
  Timer? _timer;
  final int duration = 5; // Duration in seconds
  final isLoading = false.obs;
  final _service = StoryService();

  @override
  void onInit() {
    super.onInit();
    startProgress();
  }

  void startProgress() {
    if (isLoading.value) return;
    const interval = Duration(milliseconds: 50);
    final totalSteps = (duration * 1000) / 50;
    _timer?.cancel();
    _timer = Timer.periodic(interval, (timer) {
      progress.value += 1 / totalSteps;
      if (progress.value >= 1.0) {
        progress.value = 1.0;
        _timer?.cancel();
        Get.back();
      }
    });
  }

  void pauseProgress() {
    _timer?.cancel();
  }

  void resumeProgress() {
    startProgress();
  }

  Future<void> deleteCurrentStory(String storyId) async {
    try {
      pauseProgress();
      isLoading.value = true;
      final success = await _service.deleteStory(storyId);
      if (success) {
        Utils().toastmessage("Story deleted successfully!");
        Get.back();
      } else {
        Utils().toastmessage("Failed to delete story.");
        resumeProgress();
      }
    } catch (e) {
      Utils().toastmessage(e.toString());
      resumeProgress();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
