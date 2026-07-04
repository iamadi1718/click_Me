import 'dart:convert';

import 'package:click_me/Models/CallRequestModel/CallRequestModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class CallService {
  Future<CallRequestModel> requestCall({
    required String receiverId,
    required String callType,
  }) async {
    String token = StorageService.getAccessToken();

    final response = await http.post(
      Uri.parse("${Api.baseUrl}/api/v1/chat/call/request/$receiverId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "callType": callType,
      }),
    );

    print("Status Code : ${response.statusCode}");
    print("Response : ${response.body}");

    if (response.statusCode == 200) {
      return CallRequestModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
  Future<void> acceptCall({
  required String callId,
}) async {
  String token = StorageService.getAccessToken();

  final response = await http.post(
    Uri.parse("${Api.baseUrl}/api/v1/chat/call/accept/$callId"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  print("Accept Status : ${response.statusCode}");
  print("Accept Response : ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("Failed to accept call");
  }
}

  // ================= END CALL =================

  Future<void> endCall({
    required String callId,
    String endReason = "normal",
  }) async {
    String token = StorageService.getAccessToken();

    final response = await http.post(
      Uri.parse("${Api.baseUrl}/api/v1/chat/call/end/$callId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "endReason": endReason,
      }),
    );

    print("End Call Status Code : ${response.statusCode}");
    print("End Call Response : ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to end call");
    }
  }

}