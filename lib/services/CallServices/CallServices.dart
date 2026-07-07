import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:click_me/Models/CallRequestModel/CallRequestModel.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class CallService {
  //---------------------------------------------------------
  // Headers
  //---------------------------------------------------------

  Future<Map<String, String>> _headers() async {
    final token = StorageService.getAccessToken();

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  //---------------------------------------------------------
  // Request Call
  //---------------------------------------------------------

  Future<CallRequestModel> requestCall({
    required String receiverId,
    required String callType,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("${Api.baseUrl}/api/v1/chat/call/request/$receiverId"),
            headers: await _headers(),
            body: jsonEncode({"callType": callType}),
          )
          .timeout(const Duration(seconds: 20));

      print("======================================");
      print("CALL REQUEST");
      print("Status : ${response.statusCode}");
      print(response.body);
      print("======================================");

      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(json["message"] ?? "Unable to create call.");
      }

      final model = CallRequestModel.fromJson(json);

      if (model.success != true) {
        throw Exception(model.message ?? "Call request failed.");
      }

      return model;
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } on SocketException {
      throw Exception("No internet connection.");
    } on FormatException {
      throw Exception("Invalid server response.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //---------------------------------------------------------
  // Accept Call
  //---------------------------------------------------------

  Future<CallRequestModel> acceptCall({required String callId}) async {
    print("id is,$callId");
    try {
      final response = await http
          .post(
            Uri.parse("${Api.baseUrl}/api/v1/chat/call/accept/$callId"),

            headers: await _headers(),
          )
          .timeout(const Duration(seconds: 20));

      print("======================================");
      print("CALL ACCEPT");
      print("Status : ${response.statusCode}");
      print(response.body);
      print("======================================");
 
      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(json["message"] ?? "Unable to accept call.");
      }

      final model = CallRequestModel.fromJson(json);

      if (model.success != true) {
        throw Exception(model.message ?? "Call accept failed.");
      }

      return model;
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } on SocketException {
      throw Exception("No internet connection.");
    } on FormatException {
      throw Exception("Invalid server response.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //---------------------------------------------------------
  // End Call
  //---------------------------------------------------------

  Future<bool> endCall({
    required String callId,
    String endReason = "normal",
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("${Api.baseUrl}/api/v1/chat/call/end/$callId"),
            headers: await _headers(),
            body: jsonEncode({"endReason": endReason}),
          )
          .timeout(const Duration(seconds: 20));

      print("======================================");
      print("END CALL");
      print("Status : ${response.statusCode}");
      print(response.body);
      print("======================================");

      if (response.statusCode != 200) {
        return false;
      }

      final json = jsonDecode(response.body);

      if (json is Map<String, dynamic>) {
        if (json.containsKey("success")) {
          return json["success"] == true;
        }
      }

      return true;
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } on SocketException {
      throw Exception("No internet connection.");
    } on FormatException {
      throw Exception("Invalid server response.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
