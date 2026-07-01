class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? avatar;
  final String? profileImage;
  final String? coverPhoto;
  final String gender;
  final DateTime? dob;
  final String userType;
  final String? bio;
  final String profileType;
  final bool isPrivate;
  final bool allowDownloads;
  final String status;
  final bool isVerified;
  final int loginAttempts;
  final String username;
  final bool profileCompleted;
  final List<dynamic> interests;
  final bool isOnline;
  final List<dynamic> blockedUsers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.avatar,
    this.profileImage,
    this.coverPhoto,
    required this.gender,
    this.dob,
    required this.userType,
    this.bio,
    required this.profileType,
    required this.isPrivate,
    required this.allowDownloads,
    required this.status,
    required this.isVerified,
    required this.loginAttempts,
    required this.username,
    required this.profileCompleted,
    required this.interests,
    required this.isOnline,
    required this.blockedUsers,
    this.createdAt,
    this.updatedAt,
  });

  /// Empty Model
  factory UserModel.empty() => UserModel(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    avatar: null,
    profileImage: null,
    coverPhoto: null,
    gender: '',
    dob: null,
    userType: '',
    bio: null,
    profileType: '',
    isPrivate: false,
    allowDownloads: false,
    status: '',
    isVerified: false,
    loginAttempts: 0,
    username: '',
    profileCompleted: false,
    interests: [],
    isOnline: false,
    blockedUsers: [],
    createdAt: null,
    updatedAt: null,
  );

  String get fullName => "$firstName $lastName";

  factory UserModel.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    return UserModel(
      id: json['_id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
      profileImage: json['profileImage']?.toString(),
      coverPhoto: json['coverPhoto']?.toString(),
      gender: json['gender']?.toString() ?? '',
      dob: json['dob'] != null && json['dob'].toString().isNotEmpty
          ? DateTime.tryParse(json['dob'].toString())
          : null,
      userType: json['userType']?.toString() ?? '',
      bio: json['bio']?.toString(),
      profileType: (json['profile_type'] ?? json['profileType'])?.toString() ?? '',
      isPrivate: parseBool(json['isPrivate']),
      allowDownloads: parseBool(json['allowDownloads']),
      status: json['status']?.toString() ?? '',
      isVerified: parseBool(json['isVerified']),
      loginAttempts: parseInt(json['loginAttempts']),
      username: json['username']?.toString() ?? '',
      profileCompleted: parseBool(json['profileCompleted']),
      interests: json['interests'] is List ? json['interests'] : [],
      isOnline: parseBool(json['isOnline']),
      blockedUsers: json['blockedUsers'] is List ? json['blockedUsers'] : [],
      createdAt: json['createdAt'] != null && json['createdAt'].toString().isNotEmpty
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null && json['updatedAt'].toString().isNotEmpty
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "avatar": avatar,
      "profileImage": profileImage,
      "coverPhoto": coverPhoto,
      "gender": gender,
      "dob": dob?.toIso8601String(),
      "userType": userType,
      "bio": bio,
      "profile_type": profileType,
      "isPrivate": isPrivate,
      "allowDownloads": allowDownloads,
      "status": status,
      "isVerified": isVerified,
      "loginAttempts": loginAttempts,
      "username": username,
      "profileCompleted": profileCompleted,
      "interests": interests,
      "isOnline": isOnline,
      "blockedUsers": blockedUsers,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
