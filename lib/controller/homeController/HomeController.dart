import 'package:click_me/Models/Homemodel/Homemodel.dart';
import 'package:click_me/services/Homeservices/Homeservices.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeService _service = HomeService();

  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  RxList<Posts> posts = <Posts>[].obs;

  @override
  void onInit() {
    super.onInit();
    getHomePosts();
  }

  Future<void> getHomePosts() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await _service.getHomeData();

      if (response.success == true) {
        posts.assignAll(response.data?.posts ?? []);
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

  Future<void> refreshPosts() async {
    await getHomePosts();
  }
}