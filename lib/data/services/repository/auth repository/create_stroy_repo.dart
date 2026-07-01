import 'dart:convert';
import 'dart:io';
import 'package:click_me/data/services/api_services.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/Models/Homemodel/create_story_model.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class CreateStoryRepository {
  final ApiService _api = ApiService.instance;

  // Standard JSON-based story creation API call
  Future<CreateStoryResponseModel> createStoryJson({
    required String caption,
    required String mediaUrl,
    required String mediaType,
  }) async {
    final token = StorageService.getAccessToken();
    
    final response = await _api.post(
      Api.storyUploadUrl,
      token: token,
      body: {
        "caption": caption,
        "mediaUrl": mediaUrl,
        "mediaType": mediaType,
      },
    );

    return CreateStoryResponseModel.fromJson(response);
  }

  // Multipart/File upload-based story creation API call
  Future<CreateStoryResponseModel> uploadStoryMultipart({
    required File file,
    required String caption,
    required String type,
  }) async {
    final token = StorageService.getAccessToken();
    final uri = Uri.parse(Api.storyUploadUrl);

    final request = http.MultipartRequest("POST", uri);
    
    // Set authorization and accept headers
    if (token != null && token.isNotEmpty) {
      request.headers["Authorization"] = "Bearer $token";
    }
    request.headers["Accept"] = "application/json";

    // Add fields
    request.fields["caption"] = caption;
    request.fields["type"] = type;

    // Add file
    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
    final mediaType = MediaType.parse(mimeType);
    final filename = p.basename(file.path);

    final multipartFile = await http.MultipartFile.fromPath(
      "file", // Expected key name by backend
      file.path,
      filename: filename,
      contentType: mediaType,
    );
    request.files.add(multipartFile);

    // Send request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return CreateStoryResponseModel.fromJson(decoded);
    } else {
      throw Exception("Failed to upload story: ${response.statusCode} - ${response.body}");
    }
  }
}
