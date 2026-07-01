import 'package:click_me/Models/SearchUsersModel/SearchUsersModel.dart';
import 'package:click_me/services/SearchService/SearchService.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final SearchService service = SearchService();

  RxList<UserData> users = <UserData>[].obs;
  RxBool isLoading = false.obs;

  Future<void> search(String text) async {
    if (text.isEmpty) {
      users.clear();
      return;
    }

    isLoading.value = true;

    try {
      SearchUsersModel response = await service.searchUsers(text);
      users.value = response.data?.users ?? [];
    } catch (e) {
      print(e);
    }

    isLoading.value = false;
  }
}