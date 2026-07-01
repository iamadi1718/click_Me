class GetCommentsModel {
  int? statusCode;
  Data? data;
  String? message;
  bool? success;

  GetCommentsModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  GetCommentsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<Comment>? comments;

  Data({this.comments});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  String? sId;
  User? userId;
  String? targetType;
  String? targetId;
  String? text;
  String? replyToCommentId;
  String? replyToUserId;
  int? likesCount;
  int? repliesCount;
  bool? isDeleted;
  bool? isEdited;
  String? editedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isLiked;

  Comment({
    this.sId,
    this.userId,
    this.targetType,
    this.targetId,
    this.text,
    this.replyToCommentId,
    this.replyToUserId,
    this.likesCount,
    this.repliesCount,
    this.isDeleted,
    this.isEdited,
    this.editedAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.isLiked,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
        json['user_id'] != null ? User.fromJson(json['user_id']) : null;
    targetType = json['target_type'];
    targetId = json['target_id'];
    text = json['text'];
    replyToCommentId = json['reply_to_comment_id'];
    replyToUserId = json['reply_to_user_id'];
    likesCount = json['likes_count'];
    repliesCount = json['replies_count'];
    isDeleted = json['is_deleted'];
    isEdited = json['is_edited'];
    editedAt = json['edited_at'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isLiked = json['isLiked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    if (userId != null) {
      data['user_id'] = userId!.toJson();
    }
    data['target_type'] = targetType;
    data['target_id'] = targetId;
    data['text'] = text;
    data['reply_to_comment_id'] = replyToCommentId;
    data['reply_to_user_id'] = replyToUserId;
    data['likes_count'] = likesCount;
    data['replies_count'] = repliesCount;
    data['is_deleted'] = isDeleted;
    data['is_edited'] = isEdited;
    data['edited_at'] = editedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['isLiked'] = isLiked;
    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? avatar;
  String? profileImage;
  String? username;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.profileImage,
    this.username,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    avatar = json['avatar'];
    profileImage = json['profileImage'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['avatar'] = avatar;
    data['profileImage'] = profileImage;
    data['username'] = username;
    return data;
  }
}