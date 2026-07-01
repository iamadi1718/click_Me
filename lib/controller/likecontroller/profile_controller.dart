import 'package:get/get.dart';
import 'package:click_me/Models/ProfileModel/ProfileModel.dart';
import 'package:click_me/services/Profileservices/Profileservices.dart';

class ProfileController extends GetxController {
  final ProfileService _service = ProfileService();
  final isLoading = true.obs;
  final rxProfile = Rxn<ProfileModel>();
  final errorMessage = "".obs;
  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      final data = await _service.getProfileData();
      rxProfile.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
