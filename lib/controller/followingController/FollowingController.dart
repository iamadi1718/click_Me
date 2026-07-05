import 'package:click_me/Models/FollowingModel/FollowingModel.dart';
import 'package:click_me/controller/likecontroller/profile_controller.dart';
import 'package:click_me/services/FollowingServices/FollowingServices.dart';
import 'package:get/get.dart';

class FollowingController extends GetxController {
  final FollowingService _service = FollowingService();

  RxBool isLoading = false.obs;

  RxString searchText = "".obs;

  RxList<Following> following = <Following>[].obs;

  RxList<Following> filteredFollowing = <Following>[].obs;

  /// Current button loading user id
  RxString actionLoadingId = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadFollowing();
  }

  Future<void> loadFollowing() async {
    try {
      isLoading.value = true;

      final response = await _service.getFollowingData();

      following.assignAll(response.data?.following ?? []);

      filteredFollowing.assignAll(following);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void search(String value) {
    searchText.value = value;

    if (value.trim().isEmpty) {
      filteredFollowing.assignAll(following);
      return;
    }

    final keyword = value.toLowerCase();

    filteredFollowing.assignAll(
      following.where((user) {
        final name = (user.fullName ?? "").toLowerCase();

        final username = (user.username ?? "").toLowerCase();

        return name.contains(keyword) ||
            username.contains(keyword);
      }).toList(),
    );
  }

  Future<void> unfollow(String userId) async {
  print("Unfollowing user: $userId");

  actionLoadingId.value = userId;

  final success = await _service.unfollow(userId);

  actionLoadingId.value = "";

  print("Unfollow success: $success");

  if (!success) {
    Get.snackbar("Error", "Unable to unfollow user.");
    return;
  }

  await loadFollowing();
  if (Get.isRegistered<ProfileController>()) {
  await Get.find<ProfileController>().fetchProfile();
}

  print("Following count: ${following.length}");

  Get.snackbar(
    "Success",
    "User unfollowed successfully.",
  );
}
  Future<void> refreshData() async {
    await loadFollowing();
  }
}