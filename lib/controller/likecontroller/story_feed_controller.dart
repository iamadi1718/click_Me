import 'package:get/get.dart';
import 'package:click_me/Models/Storymodel/Storymodel.dart';
import 'package:click_me/services/Storyservices/Storyservices.dart';

class StoryFeedController extends GetxController {
  final StoryService _service = StoryService();
  
  // Reactive variables
  final isLoading = false.obs;
  final error = "".obs;
  final rxStory = Rxn<StoryModel>();

  @override
  void onInit() {
    super.onInit();
    fetchStoryData();
  }

  Future<void> fetchStoryData() async {
    try {
      isLoading.value = true;
      error.value = "";
      final data = await _service.getStoryData();
      rxStory.value = data;
    } catch (e) {
      error.value = e.toString();
      print("StoryFeedController Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
