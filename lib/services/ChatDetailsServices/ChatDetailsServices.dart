import 'dart:convert';

import 'package:click_me/Models/ChatMessagesModel/ChatMessageModel.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:http/http.dart' as http;



class ChatMessageService {
  Future<ChatMessageModel> getMessages(String threadId) async {

    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2YTMzZDFhZGE2ZDMyNjM0MWE5YzEwZjQiLCJlbWFpbCI6InZhc2h2aS4wMjAyQGdtYWlsLmNvbSIsInVzZXJUeXBlIjoiYWRtaW4iLCJpYXQiOjE3ODI3OTkyMTMsImV4cCI6MTc4Mjg4NTYxM30.rtBftE0mH3FljlNfdW75biIneBxgwCOKpeVwPGOFOxc";

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