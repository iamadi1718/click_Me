import 'dart:convert';
import 'dart:io';
import 'package:click_me/data/services/network/api_exception.dart';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  /// Change according to your project
  static const String baseUrl = "http://103.207.183.10:5000";

  final Map<String, String> _defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  //======================================================
  // GET
  //======================================================

  Future<dynamic> get(
    String endpoint, {
    String? token,
    Map<String, String>? headers,
  }) async {
    return _request(
      method: "GET",
      endpoint: endpoint,
      token: token,
      headers: headers,
    );
  }

  //======================================================
  // POST
  //======================================================

  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    String? token,
    Map<String, String>? headers,
  }) async {
    return _request(
      method: "POST",
      endpoint: endpoint,
      body: body,
      token: token,
      headers: headers,
    );
  }

  //======================================================
  // PUT
  //======================================================

  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    String? token,
    Map<String, String>? headers,
  }) async {
    return _request(
      method: "PUT",
      endpoint: endpoint,
      body: body,
      token: token,
      headers: headers,
    );
  }

  //======================================================
  // PATCH
  //======================================================

  Future<dynamic> patch(
    String endpoint, {
    dynamic body,
    String? token,
    Map<String, String>? headers,
  }) async {
    return _request(
      method: "PATCH",
      endpoint: endpoint,
      body: body,
      token: token,
      headers: headers,
    );
  }

  //======================================================
  // DELETE
  //======================================================

  Future<dynamic> delete(
    String endpoint, {
    dynamic body,
    String? token,
    Map<String, String>? headers,
  }) async {
    return _request(
      method: "DELETE",
      endpoint: endpoint,
      body: body,
      token: token,
      headers: headers,
    );
  }

  //======================================================
  // COMMON REQUEST
  //======================================================

  Future<dynamic> _request({
    required String method,
    required String endpoint,
    dynamic body,
    String? token,
    Map<String, String>? headers,
  }) async {
    try {
      final uri =
          endpoint.startsWith("http")
              ? Uri.parse(endpoint)
              : Uri.parse("$baseUrl$endpoint");

      final requestHeaders = {..._defaultHeaders, ...?headers};

      if (token != null && token.isNotEmpty) {
        requestHeaders["Authorization"] = "Bearer $token";
      }

      final cleanedBody = _removeNulls(body);
      http.Response response;

      switch (method) {
        case "GET":
          response = await http.get(uri, headers: requestHeaders);
          break;

        case "POST":
          print(
            "HTTP POST: $uri\nHeaders: $requestHeaders\nBody: ${jsonEncode(cleanedBody)}",
          );
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: jsonEncode(cleanedBody),
          );
          break;

        case "PUT":
          print(
            "HTTP PUT: $uri\nHeaders: $requestHeaders\nBody: ${jsonEncode(cleanedBody)}",
          );
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: jsonEncode(cleanedBody),
          );
          break;

        case "PATCH":
          print(
            "HTTP PATCH: $uri\nHeaders: $requestHeaders\nBody: ${jsonEncode(cleanedBody)}",
          );
          response = await http.patch(
            uri,
            headers: requestHeaders,
            body: jsonEncode(cleanedBody),
          );
          break;

        case "DELETE":
          print(
            "HTTP DELETE: $uri\nHeaders: $requestHeaders\nBody: ${jsonEncode(cleanedBody)}",
          );
          response = await http.delete(
            uri,
            headers: requestHeaders,
            body: jsonEncode(cleanedBody),
          );
          break;

        default:
          throw ApiException(message: "Unsupported HTTP Method");
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        _logApiError(
          uri.toString(),
          requestHeaders,
          cleanedBody,
          response.statusCode,
          response.body,
        );
      } else {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic> && decoded['success'] == false) {
            _logApiError(
              uri.toString(),
              requestHeaders,
              cleanedBody,
              response.statusCode,
              response.body,
            );
          }
        } catch (_) {}
      }

      return _handleResponse(response);
    } on http.ClientException {
      throw ApiException(message: "No Internet Connection");
    } on FormatException {
      throw ApiException(message: "Invalid Response");
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  //======================================================
  // RESPONSE
  //======================================================

  dynamic _handleResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw ApiException(
        message: "Server returned an empty response",
        statusCode: response.statusCode,
      );
    }

    final dynamic json;
    try {
      json = jsonDecode(response.body);
    } catch (_) {
      throw ApiException(
        message: "Invalid response format from server",
        statusCode: response.statusCode,
      );
    }

    if (json is Map<String, dynamic> && json['success'] == false) {
      print("API RESPONSE ERROR BODY (success=false): $json");
      throw ApiException(
        message: json["message"]?.toString() ?? "Something went wrong",
        statusCode: json["statusCode"] as int? ?? response.statusCode,
      );
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (json == null) {
        throw ApiException(
          message: "Server returned null data",
          statusCode: response.statusCode,
        );
      }
      return json;
    }

    // Handle error status codes safely
    print("API RESPONSE ERROR BODY (status=${response.statusCode}): $json");
    String errorMessage = "Something went wrong";
    if (json is Map<String, dynamic> && json["message"] != null) {
      errorMessage = json["message"].toString();
    } else if (json is String) {
      errorMessage = json;
    }

    throw ApiException(message: errorMessage, statusCode: response.statusCode);
  }

  void _logApiError(
    String url,
    Map<String, String> headers,
    dynamic body,
    int statusCode,
    String responseBody,
  ) {
    try {
      final logMessage = """
=== API ERROR LOG ===
Timestamp: ${DateTime.now().toIso8601String()}
URL: $url
Headers: $headers
Request Body: $body
Response Status: $statusCode
Response Body: $responseBody
=====================

""";
      print(logMessage); // Print to debug console

      // Avoid writing files on read-only/mobile file systems
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        final file = File('api_error_log.txt');
        file.writeAsStringSync(logMessage, mode: FileMode.append);
      }
    } catch (e) {
      print("Failed to write api log: $e");
    }
  }

  dynamic _removeNulls(dynamic object) {
    if (object is Map) {
      final Map<String, dynamic> cleaned = {};
      object.forEach((key, value) {
        if (value != null) {
          cleaned[key.toString()] = _removeNulls(value);
        }
      });
      return cleaned;
    } else if (object is List) {
      return object.map((item) => _removeNulls(item)).toList();
    }
    return object;
  }
}
