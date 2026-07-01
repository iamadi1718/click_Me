import 'package:click_me/Models/ProfileModel/ProfileModel.dart';
import 'package:click_me/services/Profileservices/Profileservices.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileService _service = ProfileService();

  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  Rxn<ProfileData> profile = Rxn<ProfileData>();

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await _service.getProfileData();

      if (response.success == true) {
        profile.value = response.data;
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

  Future<void> refreshProfile() async {
    await getProfile();
  }
}