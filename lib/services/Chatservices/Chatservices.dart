import 'dart:convert';

import 'package:click_me/Models/ChatThreadModel/ChatThreadModel.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:http/http.dart' as http;

class ChatService {
  Future<ChatThreadModel> getChatData() async {
    try {
      String token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2YTMzZDFhZGE2ZDMyNjM0MWE5YzEwZjQiLCJlbWFpbCI6InZhc2h2aS4wMjAyQGdtYWlsLmNvbSIsInVzZXJUeXBlIjoiYWRtaW4iLCJpYXQiOjE3ODI3OTkyMTMsImV4cCI6MTc4Mjg4NTYxM30.rtBftE0mH3FljlNfdW75biIneBxgwCOKpeVwPGOFOxc";

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
