import 'dart:convert';

import 'package:click_me/Models/PostsModel/PostsModel.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:http/http.dart' as http;

class PostsService {
  Future<PostsModel> getPostsData() async {
    try {
      String token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2YTMzZDFhZGE2ZDMyNjM0MWE5YzEwZjQiLCJlbWFpbCI6InZhc2h2aS4wMjAyQGdtYWlsLmNvbSIsInVzZXJUeXBlIjoiYWRtaW4iLCJpYXQiOjE3ODI3OTkyMTMsImV4cCI6MTc4Mjg4NTYxM30.rtBftE0mH3FljlNfdW75biIneBxgwCOKpeVwPGOFOxc";

      final response = await http.get(
        Uri.parse(Api.postsUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return PostsModel.fromJson(jsonData);
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
  