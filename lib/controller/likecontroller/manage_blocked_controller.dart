import 'package:get/get.dart';
import 'package:click_me/Models/Blocked_users_model/Blocked_users_model.dart';
import 'package:click_me/services/BlockedusersServices/BlockedUsersServices.dart';

class ManageBlockedController extends GetxController {
  final BlockedUsersServices _services = BlockedUsersServices();
  final isLoading = true.obs;
  final rxBlocked = Rxn<BlockedUsersModel>();
  final errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlockedUsers();
  }

  Future<void> fetchBlockedUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      final data = await _services.getBlockData();
      rxBlocked.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unblockUser(String userId) async {
    // Unblock API can be connected here
  }
}
