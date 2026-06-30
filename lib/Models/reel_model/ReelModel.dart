class ReelsModel {
  int? statusCode;
  ReelsData? data;
  String? message;
  bool? success;

  ReelsModel({this.statusCode, this.data, this.message, this.success});

  ReelsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? ReelsData.fromJson(json['data']) : null;
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

class ReelsData {
  List<Reel>? reels;

  ReelsData({this.reels});

  ReelsData.fromJson(Map<String, dynamic> json) {
    if (json['reels'] != null) {
      reels = <Reel>[];
      json['reels'].forEach((v) {
        reels!.add(Reel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (reels != null) {
      data['reels'] = reels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reel {
  String? id;
  ReelUser? userId;
  String? caption;
  ReelMedia? media;
  ReelMusic? music;
  List<dynamic>? tags;
  int? likesCount;
  int? commentsCount;
  int? sharesCount;
  int? viewsCount;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  bool? isLiked;
  bool? isFollowing;
  bool? isSuggested;

  Reel({
    this.id,
    this.userId,
    this.caption,
    this.media,
    this.music,
    this.tags,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    this.viewsCount,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
    this.isFollowing,
    this.isSuggested,
  });

  Reel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId =
        json['user_id'] != null ? ReelUser.fromJson(json['user_id']) : null;
    caption = json['caption'];
    media =
        json['media'] != null ? ReelMedia.fromJson(json['media']) : null;
    music =
        json['music'] != null ? ReelMusic.fromJson(json['music']) : null;
    tags = json['tags'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    sharesCount = json['shares_count'];
    viewsCount = json['views_count'];
    isDeleted = json['is_deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isLiked = json['isLiked'];
    isFollowing = json['isFollowing'];
    isSuggested = json['isSuggested'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    if (userId != null) {
      data['user_id'] = userId!.toJson();
    }
    data['caption'] = caption;
    if (media != null) {
      data['media'] = media!.toJson();
    }
    if (music != null) {
      data['music'] = music!.toJson();
    }
    data['tags'] = tags;
    data['likes_count'] = likesCount;
    data['comments_count'] = commentsCount;
    data['shares_count'] = sharesCount;
    data['views_count'] = viewsCount;
    data['is_deleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isLiked'] = isLiked;
    data['isFollowing'] = isFollowing;
    data['isSuggested'] = isSuggested;
    return data;
  }
}

class ReelUser {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profileImage;
  String? avatar;

  ReelUser({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profileImage,
    this.avatar,
  });

  ReelUser.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    profileImage = json['profileImage'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['username'] = username;
    data['profileImage'] = profileImage;
    data['avatar'] = avatar;
    return data;
  }
}

class ReelMedia {
  String? url;
  String? thumbnail;
  dynamic duration;
  dynamic width;
  dynamic height;

  ReelMedia({
    this.url,
    this.thumbnail,
    this.duration,
    this.width,
    this.height,
  });

  ReelMedia.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    thumbnail = json['thumbnail'];
    duration = json['duration'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    data['duration'] = duration;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class ReelMusic {
  String? trackId;
  String? trackName;
  String? artistName;
  String? albumArt;
  String? previewUrl;
  int? startTime;

  ReelMusic({
    this.trackId,
    this.trackName,
    this.artistName,
    this.albumArt,
    this.previewUrl,
    this.startTime,
  });

  ReelMusic.fromJson(Map<String, dynamic> json) {
    trackId = json['trackId'];
    trackName = json['trackName'];
    artistName = json['artistName'];
    albumArt = json['albumArt'];
    previewUrl = json['previewUrl'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['trackId'] = trackId;
    data['trackName'] = trackName;
    data['artistName'] = artistName;
    data['albumArt'] = albumArt;
    data['previewUrl'] = previewUrl;
    data['startTime'] = startTime;
    return data;
  }
}