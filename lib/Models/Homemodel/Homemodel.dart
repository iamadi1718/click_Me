class HomeModel {
  int? statusCode;
  Data? data;
  String? message;
  bool? success;

  HomeModel({this.statusCode, this.data, this.message, this.success});

  HomeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<Posts>? posts;

  Data({this.posts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = (json['posts'] as List).map((e) => Posts.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {'posts': posts?.map((e) => e.toJson()).toList()};
  }
}

class Posts {
  String? sId;
  UserId? userId;
  String? caption;
  List<Media>? media;
  List<dynamic>? tags;
  dynamic location;
  int? likesCount;
  int? commentsCount;
  int? sharesCount;
  int? viewsCount;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  bool? isLiked;
  bool? isSuggested;

  Posts({
    this.sId,
    this.userId,
    this.caption,
    this.media,
    this.tags,
    this.location,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    this.viewsCount,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
    this.isSuggested,
  });

  Posts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    userId = json['user_id'] != null ? UserId.fromJson(json['user_id']) : null;

    caption = json['caption'];

    if (json['media'] != null) {
      media = (json['media'] as List).map((e) => Media.fromJson(e)).toList();
    }

    if (json['tags'] != null) {
      tags = List<dynamic>.from(json['tags']);
    }

    location = json['location'];

    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    sharesCount = json['shares_count'];
    viewsCount = json['views_count'];
    isDeleted = json['is_deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isLiked = json['isLiked'];
    isSuggested = json['isSuggested'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'user_id': userId?.toJson(),
      'caption': caption,
      'media': media?.map((e) => e.toJson()).toList(),
      'tags': tags,
      'location': location,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'views_count': viewsCount,
      'is_deleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isLiked': isLiked,
      'isSuggested': isSuggested,
    };
  }
}

class UserId {
  String? sId;
  String? firstName;
  String? lastName;
  String? username;
  String? profileImage;
  String? avatar;

  UserId({
    this.sId,
    this.firstName,
    this.lastName,
    this.username,
    this.profileImage,
    this.avatar,
  });

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    profileImage = json['profileImage'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'profileImage': profileImage,
      'avatar': avatar,
    };
  }
}

class Media {
  String? type;
  String? url;
  String? thumbnail;
  dynamic width;
  dynamic height;
  dynamic duration;
  String? sId;

  Media({
    this.type,
    this.url,
    this.thumbnail,
    this.width,
    this.height,
    this.duration,
    this.sId,
  });

  Media.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    width = json['width'];
    height = json['height'];
    duration = json['duration'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'thumbnail': thumbnail,
      'width': width,
      'height': height,
      'duration': duration,
      '_id': sId,
    };
  }
}
