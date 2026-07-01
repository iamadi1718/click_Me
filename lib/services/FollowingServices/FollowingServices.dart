import 'dart:convert';

import 'package:click_me/Models/FollowingModel/FollowingModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class FollowingService {
  Future<FollowingModel> getFollowingData() async {
    try {
      String token = StorageService.getAccessToken();
      String userId = StorageService.getUserId();

      final response = await http.get(
        Uri.parse("${Api.followingUrl}/$userId"),
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

        return FollowingModel.fromJson(jsonData);
      } else {
        throw Exception(
          "Failed to load data. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}

