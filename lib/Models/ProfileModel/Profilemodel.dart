class ProfileModel {
  int? statusCode;
  ProfileData? data;
  String? message;
  bool? success;

  ProfileModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null
        ? ProfileData.fromJson(json['data'])
        : null;
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

class ProfileData {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? avatar;
  String? profileImage;
  String? coverPhoto;
  String? userType;
  String? bio;
  String? profileType;
  bool? isPrivate;
  bool? allowDownloads;
  String? status;
  bool? isVerified;
  int? loginAttempts;
  String? username;
  bool? profileCompleted;
  List<dynamic>? interests;
  bool? isOnline;
  List<dynamic>? blockedUsers;
  String? createdAt;
  String? updatedAt;
  int? v;
  int? followersCount;
  int? followingCount;
  int? totalPosts;
  int? totalReels;
  int? totalSavedPosts;

  ProfileData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.avatar,
    this.profileImage,
    this.coverPhoto,
    this.userType,
    this.bio,
    this.profileType,
    this.isPrivate,
    this.allowDownloads,
    this.status,
    this.isVerified,
    this.loginAttempts,
    this.username,
    this.profileCompleted,
    this.interests,
    this.isOnline,
    this.blockedUsers,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.followersCount,
    this.followingCount,
    this.totalPosts,
    this.totalReels,
    this.totalSavedPosts,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    avatar = json['avatar'];
    profileImage = json['profileImage'];
    coverPhoto = json['coverPhoto'];
    userType = json['userType'];
    bio = json['bio'];
    profileType = json['profile_type'];
    isPrivate = json['isPrivate'];
    allowDownloads = json['allowDownloads'];
    status = json['status'];
    isVerified = json['isVerified'];
    loginAttempts = json['loginAttempts'];
    username = json['username'];
    profileCompleted = json['profileCompleted'];
    interests = json['interests'];
    isOnline = json['isOnline'];
    blockedUsers = json['blockedUsers'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
    totalPosts = json['totalPosts'];
    totalReels = json['totalReels'];
    totalSavedPosts = json['totalSavedPosts'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'profileImage': profileImage,
      'coverPhoto': coverPhoto,
      'userType': userType,
      'bio': bio,
      'profile_type': profileType,
      'isPrivate': isPrivate,
      'allowDownloads': allowDownloads,
      'status': status,
      'isVerified': isVerified,
      'loginAttempts': loginAttempts,
      'username': username,
      'profileCompleted': profileCompleted,
      'interests': interests,
      'isOnline': isOnline,
      'blockedUsers': blockedUsers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'totalPosts': totalPosts,
      'totalReels': totalReels,
      'totalSavedPosts': totalSavedPosts,
    };
  }
}