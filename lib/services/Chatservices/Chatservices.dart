import 'dart:convert';

import 'package:click_me/Models/ChatThreadModel/ChatThreadModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:http/http.dart' as http;

class ChatService {
  Future<ChatThreadModel> getChatData() async {
    try {
      String token = StorageService.getAccessToken();

      final response = await http.get(
        Uri.parse(Api.chatUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
     

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return ChatThreadModel.fromJson(jsonData);
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
