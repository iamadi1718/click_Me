import 'package:get_storage/get_storage.dart';

class StorageService {
  StorageService._();

  static final box = GetStorage();

  // Keys
  static const accessToken = "accessToken";
  static const refreshToken = "refreshToken";
  static const userId = "userId";

  // Save

  static Future<void> saveAccessToken(String token) async {
    await box.write(accessToken, token);
  }

  static Future<void> saveRefreshToken(String token) async {
    await box.write(refreshToken, token);
  }

  static Future<void> saveUserId(String id) async {
    await box.write(userId, id);
  }

  // Read

  static String getAccessToken() {
    return box.read(accessToken) ?? "";
  }

  static String getRefreshToken() {
    return box.read(refreshToken) ?? "";
  }

  static String getUserId() {
    return box.read(userId) ?? "";
  }

  // Clear

  static Future<void> clear() async {
    await box.erase();
  }
}
