class PostsModel {
  int? statusCode;
  ExploreData? data;
  String? message;
  bool? success;

  PostsModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  PostsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? ExploreData.fromJson(json['data']) : null;
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

class ExploreData {
  List<ExplorePost>? posts;
  int? page;
  int? limit;
  bool? hasMore;

  ExploreData({
    this.posts,
    this.page,
    this.limit,
    this.hasMore,
  });

  ExploreData.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = <ExplorePost>[];
      json['posts'].forEach((v) {
        posts!.add(ExplorePost.fromJson(v));
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

class ExplorePost {
  String? id;
  dynamic userId;
  String? caption;
  List<PostMedia>? media;
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

  ExplorePost({
    this.id,
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

  ExplorePost.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['user_id'];
    caption = json['caption'];

    if (json['media'] != null) {
      media = <PostMedia>[];
      json['media'].forEach((v) {
        media!.add(PostMedia.fromJson(v));
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

    data['_id'] = id;
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

class PostMedia {
  String? type;
  String? url;
  String? thumbnail;
  dynamic width;
  dynamic height;
  dynamic duration;
  String? id;

  PostMedia({
    this.type,
    this.url,
    this.thumbnail,
    this.width,
    this.height,
    this.duration,
    this.id,
  });

  PostMedia.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    width = json['width'];
    height = json['height'];
    duration = json['duration'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['type'] = type;
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    data['width'] = width;
    data['height'] = height;
    data['duration'] = duration;
    data['_id'] = id;

    return data;
  }
}