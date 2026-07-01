import 'dart:convert';
import 'package:click_me/Models/SearchUsersModel/SearchUsersModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/Api.dart';
import 'package:http/http.dart' as http;

class SearchService {
  Future<SearchUsersModel> searchUsers(String query) async {
    String token = StorageService.getAccessToken();

    final response = await http.get(
      Uri.parse("${Api.baseUrl}/search/users?query=$query"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      return SearchUsersModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}