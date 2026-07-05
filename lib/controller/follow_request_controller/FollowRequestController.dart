import 'package:click_me/Models/followRequestsModel/FollowRequestsModel.dart';
import 'package:click_me/controller/followerController/FollowerController.dart';
import 'package:click_me/controller/followingController/FollowingController.dart';
import 'package:click_me/controller/likecontroller/profile_controller.dart';
import 'package:click_me/services/FollowRequestsServices/FollowRequestsServices.dart';
import 'package:get/get.dart';

class FollowRequestsController extends GetxController {
  final FollowRequestsService _service = FollowRequestsService();

  RxBool isLoading = false.obs;

  RxString searchText = "".obs;

  RxList<RequestData> requests = <RequestData>[].obs;

  RxList<RequestData> filteredRequests = <RequestData>[].obs;

  /// Stores the user id currently performing an action
  RxString actionLoadingId = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      isLoading.value = true;

      final response = await _service.getFollowRequestsData();

      requests.assignAll(response.data ?? []);

      filteredRequests.assignAll(requests);
    } finally {
      isLoading.value = false;
    }
  }

  void search(String value) {
    searchText.value = value;

    if (value.trim().isEmpty) {
      filteredRequests.assignAll(requests);
      return;
    }

    final keyword = value.toLowerCase();

    filteredRequests.assignAll(
      requests.where((element) {
        final first =
            element.requester?.firstName?.toLowerCase() ?? "";

        final last =
            element.requester?.lastName?.toLowerCase() ?? "";



        return first.contains(keyword) ||
          last.contains(keyword);
    }).toList(),
    );
  }

  Future<void> acceptRequest(String userId) async {
    actionLoadingId.value = userId;

final success = await _service.acceptRequest(userId);
    actionLoadingId.value = "";

    if (!success) {
      Get.snackbar("Error", "Unable to accept request");
      return;
    }

    /// Refresh Requests
    await loadRequests();
    if (Get.isRegistered<ProfileController>()) {
  await Get.find<ProfileController>().fetchProfile();
}

    /// Refresh Followers
    if (Get.isRegistered<FollowersController>()) {
      await Get.find<FollowersController>().loadFollowers();
    }

    /// Refresh Following
    if (Get.isRegistered<FollowingController>()) {
      await Get.find<FollowingController>().loadFollowing();
    }

    Get.snackbar(
      "Success",
      "Request accepted successfully",
    );
  }

  Future<void> rejectRequest(String userId) async {
    actionLoadingId.value = userId;

    final success = await _service.rejectRequest(userId);

    actionLoadingId.value = "";

    if (!success) {
      Get.snackbar("Error", "Unable to reject request");
      return;
    }

    await loadRequests();
    if (Get.isRegistered<ProfileController>()) {
  await Get.find<ProfileController>().fetchProfile();
}

    if (Get.isRegistered<FollowersController>()) {
      await Get.find<FollowersController>().loadFollowers();
    }

    if (Get.isRegistered<FollowingController>()) {
      await Get.find<FollowingController>().loadFollowing();
    }

    Get.snackbar(
      "Success",
      "Request rejected successfully",
    );
  }
}