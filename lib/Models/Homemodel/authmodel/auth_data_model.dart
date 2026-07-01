import 'user_model.dart';

class AuthDataModel {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final bool profileCompleted;

  AuthDataModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.profileCompleted,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    }

    return AuthDataModel(
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : UserModel.empty(),
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      profileCompleted: parseBool(json['profileCompleted']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user.toJson(),
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "profileCompleted": profileCompleted,
    };
  }
}
