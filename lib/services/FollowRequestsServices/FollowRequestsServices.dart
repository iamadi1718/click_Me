import 'dart:convert';

import 'package:click_me/Models/followRequestsModel/FollowRequestsModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class FollowRequestsService {
  Map<String, String> get _headers {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${StorageService.getAccessToken()}",
    };
  }

  /// Get Follow Requests
  Future<Followrequestsmodel> getFollowRequestsData() async {
    try {
      final response = await http.get(
        Uri.parse(Api.followRequestsUrl),
        headers: _headers,
      );

      print("Follow Requests Status : ${response.statusCode}");
      print("Follow Requests Response : ${response.body}");

      if (response.statusCode == 200) {
        return Followrequestsmodel.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception(
        "Failed to load follow requests (${response.statusCode})",
      );
    } catch (e) {
      throw Exception("Follow Requests API Error : $e");
    }
  }

  /// Accept / Follow Back
  Future<bool> acceptRequest(String userId) async {
  try {
    final response = await http.post(
      Uri.parse("${Api.baseUrl}/api/v1/follow/accept/$userId"),
      headers: _headers,
    );

    print("Accept Status : ${response.statusCode}");
    print("Accept Response : ${response.body}");

    return response.statusCode == 200 ||
        response.statusCode == 201;
  } catch (e) {
    print(e);
    return false;
  }
}

  /// Reject Request
  Future<bool> rejectRequest(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse("${Api.baseUrl}/api/v1/follow/unfollow/$userId"),
        headers: _headers,
      );

      print("Reject Status : ${response.statusCode}");
      print("Reject Response : ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Reject Error : $e");
      return false;
    }
  }

  /// Refresh Requests
  Future<List<RequestData>> refreshRequests() async {
    final response = await getFollowRequestsData();
    return response.data ?? [];
  }
}