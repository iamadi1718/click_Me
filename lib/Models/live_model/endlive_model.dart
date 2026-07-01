class EndLiveModel {
  int? statusCode;
  EndedLiveStreamData? data;
  String? message;
  bool? success;

  EndLiveModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  EndLiveModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? EndedLiveStreamData.fromJson(json['data']) : null;
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

class EndedLiveStreamData {
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
  String? endedAt;

  EndedLiveStreamData({
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
    this.endedAt,
  });

  EndedLiveStreamData.fromJson(Map<String, dynamic> json) {
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
    endedAt = json['endedAt'];
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
      'endedAt': endedAt,
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
