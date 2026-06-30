class CallRequestModel {
  int? statusCode;
  CallData? data;
  String? message;
  bool? success;

  CallRequestModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  CallRequestModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? CallData.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['statusCode'] = statusCode;

    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }

    data['message'] = message;
    data['success'] = success;

    return data;
  }
}

class CallData {
  String? callId;
  String? callType;
  String? status;
  String? encryptionKey;

  CallData({
    this.callId,
    this.callType,
    this.status,
    this.encryptionKey,
  });

  CallData.fromJson(Map<String, dynamic> json) {
    callId = json['callId'];
    callType = json['callType'];
    status = json['status'];
    encryptionKey = json['encryptionKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['callId'] = callId;
    data['callType'] = callType;
    data['status'] = status;
    data['encryptionKey'] = encryptionKey;

    return data;
  }
}