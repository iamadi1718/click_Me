class Followrequestsmodel {
  int? statusCode;
  List<RequestData>? data;
  String? message;
  bool? success;

  Followrequestsmodel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  Followrequestsmodel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <RequestData>[];
      json['data'].forEach((v) {
        data!.add(RequestData.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class RequestData {
  String? id;
  String? followerId;
  String? followingId;
  String? status;
  Requester? requester;
  String? createdAt;

  RequestData({
    this.id,
    this.followerId,
    this.followingId,
    this.status,
    this.requester,
    this.createdAt,
  });

  RequestData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    followerId = json['follower_id'];
    followingId = json['following_id'];
    status = json['status'];
    requester = json['requester'] != null
        ? Requester.fromJson(json['requester'])
        : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['follower_id'] = followerId;
    data['following_id'] = followingId;
    data['status'] = status;
    if (requester != null) {
      data['requester'] = requester!.toJson();
    }
    data['createdAt'] = createdAt;
    return data;
  }
}

class Requester {
  String? id;
  String? firstName;
  String? lastName;
  String? profilePicture;

  Requester({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  Requester.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['profilePicture'] = profilePicture;
    return data;
  }
}