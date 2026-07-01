import 'package:click_me/Models/Storymodel/Storymodel.dart';
import 'package:click_me/services/Storyservices/Storyservices.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {
  final StoryService _service = StoryService();

  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  RxList<StoryUser> stories = <StoryUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    getStories();
  }

  Future<void> getStories() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await _service.getStoryData();

      if (response.success == true) {
        stories.assignAll(response.data?.stories ?? []);
      } else {
        errorMessage.value =
            response.message ?? "Something went wrong";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStories() async {
    await getStories();
  }
}