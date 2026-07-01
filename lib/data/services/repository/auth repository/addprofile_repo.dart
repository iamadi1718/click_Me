import 'package:click_me/data/services/api_services.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/data/services/network/api_exception.dart';
import 'package:click_me/view/utils/api.dart';

class AddProfileRepository {
  final ApiService _api = ApiService.instance;

  Future<Map<String, dynamic>> completeProfile({
    required String firstName,
    required String lastName,
    required String name,
    required String username,
    required String gender,
    required String dob,
    required List<String> interests,
  }) async {
    final token = StorageService.getAccessToken();
    final response = await _api.post(
      Api.AddprofileUrl,
      token: token,
      body: {
        "firstName": firstName,
        "lastName": lastName,
        "name": name,
        "username": username,
        "gender": gender,
        "dob": dob,
        "interests": interests,
        "bio": "",
        "avatar": "",
        "profile_type": "public",
        "profileType": "public",
      },
    );

    if (response is Map<String, dynamic>) {
      return response;
    }
    throw ApiException(message: "Invalid API response structure");
  }
}
