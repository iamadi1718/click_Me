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
    return {
      'statusCode': statusCode,
      'data': data?.toJson(),
      'message': message,
      'success': success,
    };
  }
}

class CallData {
  String? callId;
  String? callType;
  String? status;
  String? encryptionKey;

  CallUser? caller;
  CallUser? receiver;

  CallData({
    this.callId,
    this.callType,
    this.status,
    this.encryptionKey,
    this.caller,
    this.receiver,
  });

  CallData.fromJson(Map<String, dynamic> json) {
    callId = json['callId'];
    callType = json['callType'];
    status = json['status'];
    encryptionKey = json['encryptionKey'];

    caller =
        json['caller'] != null ? CallUser.fromJson(json['caller']) : null;

    receiver =
        json['receiver'] != null ? CallUser.fromJson(json['receiver']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'callType': callType,
      'status': status,
      'encryptionKey': encryptionKey,
      'caller': caller?.toJson(),
      'receiver': receiver?.toJson(),
    };
  }
}

class CallUser {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePicture;

  CallUser({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePicture,
  });

  CallUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'profilePicture': profilePicture,
    };
  }

  /// Convenience getter
  String get fullName {
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }
}