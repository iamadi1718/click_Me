class StoryModel {
  int? statusCode;
  StoryData? data;
  String? message;
  bool? success;

  StoryModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  StoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? StoryData.fromJson(json['data']) : null;
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

class StoryData {
  List<StoryUser>? stories;

  StoryData({this.stories});

  StoryData.fromJson(Map<String, dynamic> json) {
    if (json['stories'] != null) {
      stories = <StoryUser>[];
      json['stories'].forEach((v) {
        stories!.add(StoryUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'stories': stories?.map((e) => e.toJson()).toList(),
    };
  }
}

class StoryUser {
  User? user;
  List<Story>? stories;

  StoryUser({
    this.user,
    this.stories,
  });

  StoryUser.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    if (json['stories'] != null) {
      stories = <Story>[];
      json['stories'].forEach((v) {
        stories!.add(Story.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'stories': stories?.map((e) => e.toJson()).toList(),
    };
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePicture;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePicture,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'profilePicture': profilePicture,
    };
  }
}

class Story {
  String? id;
  StoryUserInfo? userId;
  Media? media;
  dynamic music;
  String? filter;
  String? replySettings;
  String? privacy;
  int? viewsCount;
  int? viewCount;
  String? expiresAt;
  bool? isDeleted;
  List<dynamic>? views;
  String? createdAt;
  String? updatedAt;
  int? v;

  Story({
    this.id,
    this.userId,
    this.media,
    this.music,
    this.filter,
    this.replySettings,
    this.privacy,
    this.viewsCount,
    this.viewCount,
    this.expiresAt,
    this.isDeleted,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Story.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['user_id'] != null
        ? StoryUserInfo.fromJson(json['user_id'])
        : null;
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    music = json['music'];
    filter = json['filter'];
    replySettings = json['reply_settings'];
    privacy = json['privacy'];
    viewsCount = json['views_count'];
    viewCount = json['viewCount'];
    expiresAt = json['expires_at'];
    isDeleted = json['is_deleted'];
    views = json['views'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId?.toJson(),
      'media': media?.toJson(),
      'music': music,
      'filter': filter,
      'reply_settings': replySettings,
      'privacy': privacy,
      'views_count': viewsCount,
      'viewCount': viewCount,
      'expires_at': expiresAt,
      'is_deleted': isDeleted,
      'views': views,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class StoryUserInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? avatar;
  String? profileImage;
  String? username;

  StoryUserInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.profileImage,
    this.username,
  });

  StoryUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    avatar = json['avatar'];
    profileImage = json['profileImage'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'profileImage': profileImage,
      'username': username,
    };
  }
}

class Media {
  String? type;
  String? url;
  String? thumbnail;
  String? publicId;

  Media({
    this.type,
    this.url,
    this.thumbnail,
    this.publicId,
  });

  Media.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    publicId = json['public_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'thumbnail': thumbnail,
      'public_id': publicId,
    };
  }
}