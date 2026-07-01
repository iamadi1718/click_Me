import 'dart:convert';

import 'package:click_me/Models/Storymodel/Storymodel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;
class StoryService {
  Future<StoryModel> getStoryData() async {
    try {
      String token = StorageService.getAccessToken();

      final response = await http.get(
        Uri.parse(Api.storyUrl),
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

        return StoryModel.fromJson(jsonData);
      } else {
        throw Exception(
          "Story Feed API failed. Status Code: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  Future<bool> deleteStory(String storyId) async {
    try {
      String token = StorageService.getAccessToken();
      final url = "${Api.deleteStoryBaseUrl}/$storyId";
      print("=== DELETE STORY DEBUG ===");
      print("Story ID: $storyId");
      print("Delete URL: $url");
      print("Token available: ${token.isNotEmpty}");
      
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("==========================");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
          "Failed to delete story. Status Code: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Failed to delete story: $e");
    }
  }
}
  
