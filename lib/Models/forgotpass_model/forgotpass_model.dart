class ForgotPassModel {
  int? statusCode;
  ForgotPassData? data;
  String? message;
  bool? success;

  ForgotPassModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  ForgotPassModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? ForgotPassData.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class ForgotPassData {
  String? message;
  String? email;
  int? expiresIn;

  ForgotPassData({this.message, this.email, this.expiresIn});

  ForgotPassData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    email = json['email'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['email'] = email;
    data['expiresIn'] = expiresIn;
    return data;
  }
}
