import 'dart:convert';

import 'package:click_me/Models/CommentLikeModel/CommentLikeModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:http/http.dart' as http;

class CommentLikeService {
  Future<CommentLikeModel> likeComment(String commentId) async {
    try {
      String token = StorageService.getAccessToken();

      final response = await http.post(
        Uri.parse("${Api.commentLikeUrl}/$commentId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return CommentLikeModel.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception(
          "Failed to like comment\n${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}