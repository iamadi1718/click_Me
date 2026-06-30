import 'dart:convert';

import 'package:click_me/Models/CallRequestModel/CallRequestModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/Api.dart';
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
      return CallRequestModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(response.body);
    }
  }
}