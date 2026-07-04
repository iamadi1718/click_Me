class SendMessageModel {
  int? statusCode;
  MessageData? data;
  String? message;
  bool? success;

  SendMessageModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null
        ? MessageData.fromJson(json['data'])
        : null;
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

class MessageData {
  String? threadId;
  SenderId? senderId;
  String? receiverId;
  String? messageType;
  String? encryptedContent;
  Location? location;
  dynamic replyTo;
  String? status;
  bool? isEdited;
  bool? isForwarded;
  bool? isDeleted;
  List<dynamic>? deletedFor;
  String? id;
  List<dynamic>? media;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? text;

  MessageData({
    this.threadId,
    this.senderId,
    this.receiverId,
    this.messageType,
    this.encryptedContent,
    this.location,
    this.replyTo,
    this.status,
    this.isEdited,
    this.isForwarded,
    this.isDeleted,
    this.deletedFor,
    this.id,
    this.media,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.text,
  });

  MessageData.fromJson(Map<String, dynamic> json) {
    threadId = json['threadId'];
    senderId = json['senderId'] != null
        ? SenderId.fromJson(json['senderId'])
        : null;
    receiverId = json['receiverId'];
    messageType = json['messageType'];
    encryptedContent = json['encryptedContent'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    replyTo = json['replyTo'];
    status = json['status'];
    isEdited = json['isEdited'];
    isForwarded = json['isForwarded'];
    isDeleted = json['isDeleted'];
    deletedFor = json['deletedFor'];
    id = json['_id'];
    media = json['media'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['threadId'] = threadId;
    if (senderId != null) {
      data['senderId'] = senderId!.toJson();
    }
    data['receiverId'] = receiverId;
    data['messageType'] = messageType;
    data['encryptedContent'] = encryptedContent;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['replyTo'] = replyTo;
    data['status'] = status;
    data['isEdited'] = isEdited;
    data['isForwarded'] = isForwarded;
    data['isDeleted'] = isDeleted;
    data['deletedFor'] = deletedFor;
    data['_id'] = id;
    data['media'] = media;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    data['text'] = text;
    return data;
  }
}

class SenderId {
  String? id;
  String? firstName;
  String? lastName;
  String? username;

  SenderId({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
  });

  SenderId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['username'] = username;
    return data;
  }
}

class Location {
  bool? isLiveLocation;

  Location({this.isLiveLocation});

  Location.fromJson(Map<String, dynamic> json) {
    isLiveLocation = json['isLiveLocation'];
  }

  Map<String, dynamic> toJson() {
    return {
      'isLiveLocation': isLiveLocation,
    };
  }
}