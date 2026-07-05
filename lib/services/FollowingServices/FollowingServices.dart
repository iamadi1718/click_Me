import 'dart:convert';

import 'package:click_me/Models/FollowingModel/FollowingModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class FollowingService {
  Map<String, String> get _headers {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${StorageService.getAccessToken()}",
    };
  }

  /// Get Following List
  Future<FollowingModel> getFollowingData() async {
    try {
      final userId = StorageService.getUserId();

      final response = await http.get(
        Uri.parse("${Api.followingUrl}/$userId"),
        headers: _headers,
      );

      print("Following Status Code : ${response.statusCode}");
      print("Following Response : ${response.body}");

      if (response.statusCode == 200) {
        return FollowingModel.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception(
        "Failed to fetch following (${response.statusCode})",
      );
    } catch (e) {
      throw Exception("Following API Error : $e");
    }
  }

  /// Unfollow User
  Future<bool> unfollow(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse("${Api.baseUrl}/api/v1/follow/unfollow/$userId"),
        headers: _headers,
      );

      print("Unfollow Status : ${response.statusCode}");
      print("Unfollow Response : ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Unfollow Error : $e");
      return false;
    }
  }

  /// Refresh Following List
  Future<List<Following>> refreshFollowing() async {
    final response = await getFollowingData();
    return response.data?.following ?? [];
  }
}