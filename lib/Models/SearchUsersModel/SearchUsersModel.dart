class SearchUsersModel {
  int? statusCode;
  SearchData? data;
  String? message;
  bool? success;

  SearchUsersModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  SearchUsersModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? SearchData.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }
}

class SearchData {
  List<UserData>? users;

  SearchData({this.users});

  SearchData.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users!.add(UserData.fromJson(v));
      });
    }
  }
}

class UserData {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? username;
  String? bio;
  String? profileImage;
  bool? isFollowing;
  bool? isPrivate;
  bool? isVerified;
  int? followersCount;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.username,
    this.bio,
    this.profileImage,
    this.isFollowing,
    this.isPrivate,
    this.isVerified,
    this.followersCount,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    username = json['username'];
    bio = json['bio'];
    profileImage = json['profileImage'];
    isFollowing = json['isFollowing'];
    isPrivate = json['isPrivate'];
    isVerified = json['isVerified'];
    followersCount = json['followers_count'];
  }
}