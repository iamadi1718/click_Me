import 'dart:convert';

import 'package:click_me/Models/AddCommentModel/AddCommentModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:http/http.dart' as http;

class CommentService {
  Future<AddCommentModel> addComment({
    required String postId,
    required String comment,
  }) async {
    try {
      String token = StorageService.getAccessToken();

      final response = await http.post(
        Uri.parse(
          "${Api.baseUrl}/api/v1/post/comment/$postId?name=$postId&type=post",
        ),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "text": comment,
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);

        return AddCommentModel.fromJson(jsonData);
      } else {
        throw Exception(
          "Failed to add comment. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}