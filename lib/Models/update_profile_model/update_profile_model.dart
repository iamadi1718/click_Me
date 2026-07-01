class UpdateProfileModel {
  int? statusCode;
  UpdateProfileData? data;
  String? message;
  bool? success;

  UpdateProfileModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? UpdateProfileData.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class UpdateProfileData {
  UpdatedUser? user;

  UpdateProfileData({this.user});

  UpdateProfileData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UpdatedUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class UpdatedUser {
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

  UpdatedUser({
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
  });

  UpdatedUser.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['avatar'] = avatar;
    data['profileImage'] = profileImage;
    data['coverPhoto'] = coverPhoto;
    data['userType'] = userType;
    data['bio'] = bio;
    data['profile_type'] = profileType;
    data['isPrivate'] = isPrivate;
    data['allowDownloads'] = allowDownloads;
    data['status'] = status;
    data['isVerified'] = isVerified;
    data['loginAttempts'] = loginAttempts;
    data['username'] = username;
    data['profileCompleted'] = profileCompleted;
    data['interests'] = interests;
    data['isOnline'] = isOnline;
    data['blockedUsers'] = blockedUsers;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
