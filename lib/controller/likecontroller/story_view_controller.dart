import 'dart:async';
import 'dart:convert';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/services/Storyservices/Storyservices.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:get/get.dart';
import 'package:click_me/controller/likecontroller/story_feed_controller.dart';
import 'package:http/http.dart' as http;

class StoryViewController extends GetxController {
  final progress = 0.0.obs;
  Timer? _timer;
  final int duration = 10; // 10 seconds per story
  final isLoading = false.obs;
  final viewCount = 0.obs; // dynamic view count from API
  final _service = StoryService();

  void startProgress() {
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

  bool _initialized = false;

  void initStory({required String? storyId, required bool isMyStory, required int initialViews}) {
    if (_initialized) return;
    _initialized = true;
    
    progress.value = 0.0;
    viewCount.value = initialViews;
    
    // Track views only if it's NOT our own story
    if (!isMyStory && storyId != null) {
      trackView(storyId);
    }
    startProgress();
  }

  /// Call POST /api/v1/story/view/{storyId}
  /// Tracks view and returns viewCount from API
  Future<void> trackView(String? storyId) async {
    if (storyId == null || storyId.isEmpty) return;
    try {
      final token = StorageService.getAccessToken();
      final response = await http.post(
        Uri.parse('${Api.viewStoryBaseUrl}/$storyId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final count = json['data']?['viewCount'];
        // Only update if count is valid and not 0 (since own story check can return 0)
        if (count != null && count > 0) {
          viewCount.value = count as int;
        }
      }
    } catch (e) {
      // Silently ignore
    }
  }

  Future<void> deleteCurrentStory(String storyId) async {
    try {
      pauseProgress();
      isLoading.value = true;
      final success = await _service.deleteStory(storyId);
      if (success) {
        Utils().toastmessage('Story deleted successfully!');
        if (Get.isRegistered<StoryFeedController>()) {
          Get.find<StoryFeedController>().fetchStoryData();
        }
        Get.back();
      } else {
        Utils().toastmessage('Failed to delete story.');
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

