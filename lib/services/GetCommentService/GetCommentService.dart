import 'dart:convert';

import 'package:click_me/Models/GetCommentsModel/GetCommentsModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:http/http.dart' as http;

class GetCommentsService {
  Future<GetCommentsModel> getComments(String postId) async {
    try {
      String token = StorageService.getAccessToken();

      final response = await http.get(
        Uri.parse("${Api.getCommentsUrl}/$postId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return GetCommentsModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load comments");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}