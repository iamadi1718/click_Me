import 'dart:convert';

import 'package:click_me/Models/Followersmodel/FollowersModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class FollowersService {
  Map<String, String> get _headers {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${StorageService.getAccessToken()}",
    };
  }

  /// Get Followers
  Future<FollowersModel> getFollowersData() async {
    try {
      final userId = StorageService.getUserId();

      final response = await http.get(
        Uri.parse("${Api.followersUrl}/$userId"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return FollowersModel.fromJson(jsonDecode(response.body));
      }

      throw Exception(
        "Failed to fetch followers (${response.statusCode})",
      );
    } catch (e) {
      throw Exception("Followers API Error: $e");
    }
  }

  /// Follow Back
  Future<bool> followBack(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("${Api.baseUrl}/api/v1/follow/follow-back/$userId"),
        headers: _headers,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return true;
      }

      print("Follow Back Failed");
      print(response.statusCode);
      print(response.body);

      return false;
    } catch (e) {
      print("Follow Back Error : $e");
      return false;
    }
  }

  /// Remove Follower / Unfollow
  Future<bool> unfollow(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse("${Api.baseUrl}/api/v1/follow/unfollow/$userId"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return true;
      }

      print("Unfollow Failed");
      print(response.statusCode);
      print(response.body);

      return false;
    } catch (e) {
      print("Unfollow Error : $e");
      return false;
    }
  }

  /// Refresh Followers
  Future<List<Followers>> refreshFollowers() async {
    final response = await getFollowersData();
    return response.data?.followers ?? [];
  }
}