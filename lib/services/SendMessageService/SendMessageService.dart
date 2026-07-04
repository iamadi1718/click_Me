import 'dart:convert';

import 'package:click_me/Models/SendMessageModel/SendMessageModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class SendMessageService {
  Future<SendMessageModel> sendMessage({
    required String threadId,
    required String receiverId,
    required String message,
  }) async {
    try {
      String token = StorageService.getAccessToken();

      final response = await http.post(
        Uri.parse("${Api.sendMessagesUrl}/$threadId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "threadId": threadId,
          "receiverId": receiverId,
          "messageType": "text",
          "text": message,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return SendMessageModel.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception(
          "Failed to send message\n${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}