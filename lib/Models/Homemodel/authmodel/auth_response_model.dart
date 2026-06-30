import 'auth_data_model.dart';
import 'user_model.dart';

class AuthResponseModel {
  final int statusCode;
  final bool success;
  final String message;
  final AuthDataModel data;

  AuthResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    return AuthResponseModel(
      statusCode: parseInt(json['statusCode']),
      success: parseBool(json['success']),
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? AuthDataModel.fromJson(json['data'])
          : AuthDataModel(
              user: UserModel.empty(),
              accessToken: json['accessToken']?.toString() ?? '',
              refreshToken: json['refreshToken']?.toString() ?? '',
              profileCompleted: false,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "statusCode": statusCode,
      "success": success,
      "message": message,
      "data": data.toJson(),
    };
  }
}
