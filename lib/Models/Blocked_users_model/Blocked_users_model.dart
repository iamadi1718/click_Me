class BlockedUsersModel {
  int? statusCode;
  BlockedUsersData? data;
  String? message;
  bool? success;

  BlockedUsersModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  BlockedUsersModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null
        ? BlockedUsersData.fromJson(json['data'])
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

class BlockedUsersData {
  List<BlockedUser>? blockedUsers;
  Pagination? pagination;

  BlockedUsersData({
    this.blockedUsers,
    this.pagination,
  });

  BlockedUsersData.fromJson(Map<String, dynamic> json) {
    if (json['blockedUsers'] != null) {
      blockedUsers = <BlockedUser>[];
      json['blockedUsers'].forEach((v) {
        blockedUsers!.add(BlockedUser.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (blockedUsers != null) {
      data['blockedUsers'] =
          blockedUsers!.map((e) => e.toJson()).toList();
    }

    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }

    return data;
  }
}

class BlockedUser {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? profileImage;
  String? bio;
  bool? isVerified;

  BlockedUser({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.profileImage,
    this.bio,
    this.isVerified,
  });

  BlockedUser.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    profileImage = json['profileImage'];
    bio = json['bio'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'profileImage': profileImage,
      'bio': bio,
      'isVerified': isVerified,
    };
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalBlocked;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalBlocked,
    this.hasNextPage,
    this.hasPrevPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalBlocked = json['totalBlocked'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalBlocked': totalBlocked,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}