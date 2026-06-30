class FollowingModel {
  int? statusCode;
  Data? data;
  String? message;
  bool? success;

  FollowingModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  FollowingModel.fromJson(Map<String, dynamic> json) {
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
  List<Following>? following;
  Pagination? pagination;

  Data({
    this.following,
    this.pagination,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['following'] != null) {
      following = <Following>[];
      json['following'].forEach((v) {
        following!.add(Following.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (following != null) {
      data['following'] = following!.map((v) => v.toJson()).toList();
    }

    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }

    return data;
  }
}

class Following {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? username;
  String? profilePicture;
  String? avatar;
  String? bio;
  bool? isVerified;
  bool? isPrivate;
  bool? isFollowing;
  bool? isPending;

  Following({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.username,
    this.profilePicture,
    this.avatar,
    this.bio,
    this.isVerified,
    this.isPrivate,
    this.isFollowing,
    this.isPending,
  });

  Following.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    username = json['username'];
    profilePicture = json['profilePicture'];
    avatar = json['avatar'];
    bio = json['bio'];
    isVerified = json['isVerified'];
    isPrivate = json['isPrivate'];
    isFollowing = json['isFollowing'];
    isPending = json['isPending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['fullName'] = fullName;
    data['username'] = username;
    data['profilePicture'] = profilePicture;
    data['avatar'] = avatar;
    data['bio'] = bio;
    data['isVerified'] = isVerified;
    data['isPrivate'] = isPrivate;
    data['isFollowing'] = isFollowing;
    data['isPending'] = isPending;

    return data;
  }
}

class Pagination {
  int? page;
  int? limit;
  int? total;
  bool? hasMore;

  Pagination({
    this.page,
    this.limit,
    this.total,
    this.hasMore,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    hasMore = json['hasMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['hasMore'] = hasMore;

    return data;
  }
}