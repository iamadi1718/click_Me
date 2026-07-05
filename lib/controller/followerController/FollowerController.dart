import 'package:click_me/Models/Followersmodel/FollowersModel.dart';
import 'package:click_me/controller/followingController/FollowingController.dart';
import 'package:click_me/controller/likecontroller/profile_controller.dart';
import 'package:click_me/services/FollowersServices/FollowersServices.dart';
import 'package:get/get.dart';

class FollowersController extends GetxController {
  final FollowersService _service = FollowersService();

  RxBool isLoading = false.obs;

  RxString searchText = "".obs;

  RxList<Followers> followers = <Followers>[].obs;

  RxList<Followers> filteredFollowers = <Followers>[].obs;

  /// Stores the user id currently performing an action
  RxString actionLoadingId = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadFollowers();
  }

  Future<void> loadFollowers() async {
    try {
      isLoading.value = true;

      final response = await _service.getFollowersData();

      followers.assignAll(response.data?.followers ?? []);

      filteredFollowers.assignAll(followers);
    } finally {
      isLoading.value = false;
    }
  }

  void search(String value) {
    searchText.value = value;

    if (value.trim().isEmpty) {
      filteredFollowers.assignAll(followers);
      return;
    }

    final keyword = value.toLowerCase();

    filteredFollowers.assignAll(
      followers.where((user) {
        final name = (user.fullName ?? "").toLowerCase();

        final username = (user.username ?? "").toLowerCase();

        return name.contains(keyword) ||
            username.contains(keyword);
      }).toList(),
    );
  }

  Future<void> followBack(String userId) async {
    actionLoadingId.value = userId;

    final success = await _service.followBack(userId);

    actionLoadingId.value = "";

    if (!success) {
      Get.snackbar(
        "Error",
        "Unable to follow back.",
      );
      return;
    }

    await loadFollowers();
    if (Get.isRegistered<ProfileController>()) {
  await Get.find<ProfileController>().fetchProfile();
}

    if (Get.isRegistered<FollowingController>()) {
      await Get.find<FollowingController>()
          .loadFollowing();
    }

    Get.snackbar(
      "Success",
      "Followed back successfully.",
    );
  }

  Future<void> removeFollower(String userId) async {
    actionLoadingId.value = userId;

    final success = await _service.unfollow(userId);

    actionLoadingId.value = "";

    if (!success) {
      Get.snackbar(
        "Error",
        "Unable to remove follower.",
      );
      return;
    }

    await loadFollowers();
    if (Get.isRegistered<ProfileController>()) {
  await Get.find<ProfileController>().fetchProfile();
}

    if (Get.isRegistered<FollowingController>()) {
      await Get.find<FollowingController>()
          .loadFollowing();
    }

    Get.snackbar(
      "Success",
      "Follower removed.",
    );
  }

  Future<void> refreshData() async {
    await loadFollowers();
  }
}