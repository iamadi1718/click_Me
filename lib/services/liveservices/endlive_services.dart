import 'dart:convert';
import 'package:click_me/Models/live_model/endlive_model.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class EndLiveService {
  Future<EndLiveModel> endLiveStream(String streamId) async {
    try {
      final token = StorageService.getAccessToken();

      final response = await http.post(
        Uri.parse("${Api.endliveUrl}/$streamId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("End Live API Status: ${response.statusCode}");
      print("End Live API Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return EndLiveModel.fromJson(jsonData);
      } else {
        throw Exception(
          "End Live API failed. Status Code: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Something went wrong while ending live: $e");
    }
  }
}

