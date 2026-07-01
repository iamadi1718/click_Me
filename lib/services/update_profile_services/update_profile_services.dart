// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:click_me/Models/update_profile_model/update_profile_model.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class UpdateProfileService {
  Future<UpdateProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String bio,
    String? gender,
    String? dob,
    File? avatarFile,
  }) async {
    try {
      final token = StorageService.getAccessToken();
      final uri = Uri.parse(Api.updateprofileUrl);
      
      final request = http.MultipartRequest("PUT", uri);
      
      if (token.isNotEmpty) {
        request.headers["Authorization"] = "Bearer $token";
      }
      request.headers["Accept"] = "application/json";
      
      // Add text fields
      request.fields["firstName"] = firstName;
      request.fields["lastName"] = lastName;
      request.fields["username"] = username;
      request.fields["bio"] = bio;
      if (gender != null && gender.isNotEmpty) {
        request.fields["gender"] = gender;
      }
      if (dob != null && dob.isNotEmpty) {
        request.fields["dob"] = dob;
      }
      
      // Add avatar file if present
      if (avatarFile != null) {
        final mimeType = lookupMimeType(avatarFile.path) ?? 'image/jpeg';
        final mediaType = MediaType.parse(mimeType);
        final filename = p.basename(avatarFile.path);
        
        final multipartFile = await http.MultipartFile.fromPath(
          "avatar", // Expected file key name by backend
          avatarFile.path,
          filename: filename,
          contentType: mediaType,
        );
        request.files.add(multipartFile);
      }
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Update Profile Status: ${response.statusCode}");
      print("Update Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return UpdateProfileModel.fromJson(decoded);
      } else {
        throw Exception(
          "Update Profile failed. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Something went wrong during update: $e");
    }
  }
}

