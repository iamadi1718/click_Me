class StartLiveModel {
  int? statusCode;
  LiveStreamData? data;
  String? message;
  bool? success;

  StartLiveModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  StartLiveModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? LiveStreamData.fromJson(json['data']) : null;
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

class LiveStreamData {
  String? id;
  dynamic streamerId; // Can be a String (ID) or StreamerInfo (object)
  String? title;
  String? description;
  String? thumbnail;
  String? status;
  int? viewerCount;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? startedAt;

  LiveStreamData({
    this.id,
    this.streamerId,
    this.title,
    this.description,
    this.thumbnail,
    this.status,
    this.viewerCount,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.startedAt,
  });

  LiveStreamData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    if (json['streamerId'] is Map<String, dynamic>) {
      streamerId = StreamerInfo.fromJson(json['streamerId']);
    } else {
      streamerId = json['streamerId'];
    }
    title = json['title'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    status = json['status'];
    viewerCount = json['viewerCount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    startedAt = json['startedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'streamerId': streamerId is StreamerInfo ? (streamerId as StreamerInfo).toJson() : streamerId,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'status': status,
      'viewerCount': viewerCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'startedAt': startedAt,
    };
  }
}

class StreamerInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? avatar;
  String? username;

  StreamerInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.username,
  });

  StreamerInfo.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    avatar = json['avatar'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'username': username,
    };
  }
}
