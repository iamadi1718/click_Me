class AddCommentModel {
  int? statusCode;
  CommentData? data;
  String? message;
  bool? success;

  AddCommentModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  AddCommentModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data =
        json['data'] != null ? CommentData.fromJson(json['data']) : null;
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

class CommentData {
  String? id;
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
  int? v;

  CommentData({
    this.id,
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
    this.v,
  });

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['user_id'] != null
        ? User.fromJson(json['user_id'])
        : null;
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
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = id;

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
    data['__v'] = v;

    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? username;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
  });

  User.fromJson(Map<String, dynamic> json) {
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