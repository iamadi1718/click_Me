class ExplorePostsModel {
  int? statusCode;
  Data? data;
  String? message;
  bool? success;

  ExplorePostsModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  ExplorePostsModel.fromJson(Map<String, dynamic> json) {
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
  List<Post>? posts;
  int? page;
  int? limit;
  bool? hasMore;

  Data({
    this.posts,
    this.page,
    this.limit,
    this.hasMore,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = <Post>[];
      json['posts'].forEach((v) {
        posts!.add(Post.fromJson(v));
      });
    }

    page = json['page'];
    limit = json['limit'];
    hasMore = json['hasMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }

    data['page'] = page;
    data['limit'] = limit;
    data['hasMore'] = hasMore;

    return data;
  }
}

class Post {
  String? sId;
  dynamic userId;
  String? caption;
  List<Media>? media;
  List<dynamic>? tags;
  dynamic location;
  int? likesCount;
  int? commentsCount;
  int? sharesCount;
  int? savesCount;
  int? viewsCount;
  bool? isLiked;
  bool? isSaved;
  bool? canDownload;
  String? createdAt;

  Post({
    this.sId,
    this.userId,
    this.caption,
    this.media,
    this.tags,
    this.location,
    this.likesCount,
    this.commentsCount,
    this.sharesCount,
    this.savesCount,
    this.viewsCount,
    this.isLiked,
    this.isSaved,
    this.canDownload,
    this.createdAt,
  });

  Post.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    caption = json['caption'];

    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }

    tags = json['tags'];

    location = json['location'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    sharesCount = json['shares_count'];
    savesCount = json['saves_count'];
    viewsCount = json['views_count'];
    isLiked = json['isLiked'];
    isSaved = json['isSaved'];
    canDownload = json['canDownload'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = sId;
    data['user_id'] = userId;
    data['caption'] = caption;

    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }

    data['tags'] = tags;
    data['location'] = location;
    data['likes_count'] = likesCount;
    data['comments_count'] = commentsCount;
    data['shares_count'] = sharesCount;
    data['saves_count'] = savesCount;
    data['views_count'] = viewsCount;
    data['isLiked'] = isLiked;
    data['isSaved'] = isSaved;
    data['canDownload'] = canDownload;
    data['createdAt'] = createdAt;

    return data;
  }
}

class Media {
  String? type;
  String? url;
  String? thumbnail;
  dynamic width;
  dynamic height;
  dynamic duration;
  String? sId;

  Media({
    this.type,
    this.url,
    this.thumbnail,
    this.width,
    this.height,
    this.duration,
    this.sId,
  });

  Media.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    width = json['width'];
    height = json['height'];
    duration = json['duration'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['type'] = type;
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    data['width'] = width;
    data['height'] = height;
    data['duration'] = duration;
    data['_id'] = sId;

    return data;
  }
}