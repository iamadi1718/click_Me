import 'package:click_me/Models/Blocked_users_model/Blocked_users_model.dart';
import 'package:click_me/services/BlockedusersServices/BlockedUsersServices.dart';
import 'package:get/get.dart';

class BlockedUsersController extends GetxController {
  final BlockedUsersServices _services = BlockedUsersServices();

  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  RxList<BlockedUser> blockedUsers = <BlockedUser>[].obs;

  Rx<Pagination?> pagination = Rx<Pagination?>(null);

  @override
  void onInit() {
    super.onInit();
    getBlockedUsers();
  }

  Future<void> getBlockedUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await _services.getBlockData();

      if (response.success == true) {
        blockedUsers.assignAll(
          response.data?.blockedUsers ?? [],
        );

        pagination.value = response.data?.pagination;
      } else {
        errorMessage.value = response.message ?? "Something went wrong";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBlockedUsers() async {
    await getBlockedUsers();
  }
}