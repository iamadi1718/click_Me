import 'dart:convert';

import 'package:click_me/Models/ChatMessagesModel/ChatMessageModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;



class ChatMessageService {
  Future<ChatMessageModel> getMessages(String threadId) async {

    String token = StorageService.getAccessToken();

    final response = await http.get(
       Uri.parse("${Api.chatMessagesUrl}/$threadId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return ChatMessageModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
    "Status: ${response.statusCode}\n${response.body}");
  }
}
