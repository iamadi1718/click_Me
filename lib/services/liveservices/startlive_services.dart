import 'dart:convert';
import 'package:click_me/Models/live_model/startlive_model.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class StartLiveService {
  Future<StartLiveModel> startLiveStream({String? title, String? description}) async {
    try {
      final token = StorageService.getAccessToken();

      final response = await http.post(
        Uri.parse(Api.createliveUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "title": (title != null && title.trim().isNotEmpty)
              ? title.trim()
              : "Live Stream",
          if (description != null && description.trim().isNotEmpty)
            "description": description.trim(),
        }),
      );

      print("Start Live API Status: ${response.statusCode}");
      print("Start Live API Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return StartLiveModel.fromJson(jsonData);
      } else {
        throw Exception(
          "Start Live API failed. Status Code: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Something went wrong while starting live: $e");
    }
  }
}

