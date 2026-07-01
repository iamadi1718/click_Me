class CommentLikeModel {
  int? statusCode;
  Data? data;
  String? message;
  bool? success;

  CommentLikeModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  CommentLikeModel.fromJson(Map<String, dynamic> json) {
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
  bool? isLiked;
  int? likesCount;

  Data({
    this.isLiked,
    this.likesCount,
  });

  Data.fromJson(Map<String, dynamic> json) {
    isLiked = json['isLiked'];
    likesCount = json['likes_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['isLiked'] = isLiked;
    data['likes_count'] = likesCount;

    return data;
  }
}