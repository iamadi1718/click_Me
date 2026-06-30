import 'dart:convert';

import 'package:click_me/Models/ProfileModel/ProfileModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:http/http.dart' as http;
class ProfileService {
  Future<ProfileModel> getProfileData() async {
    try {
      String token = StorageService.getAccessToken();

      final response = await http.get(
        Uri.parse(Api.profileUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return ProfileModel.fromJson(jsonData);
      } else {
        throw Exception(
          "Profile API failed. Status Code: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}
  