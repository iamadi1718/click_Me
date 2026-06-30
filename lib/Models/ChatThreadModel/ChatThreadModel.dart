class ChatThreadModel {
  int? statusCode;
  ChatData? data;
  String? message;
  bool? success;

  ChatThreadModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  ChatThreadModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? ChatData.fromJson(json['data']) : null;
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

class ChatData {
  List<Thread>? threads;
  int? total;
  int? limit;
  int? skip;
  bool? hasMore;

  ChatData({
    this.threads,
    this.total,
    this.limit,
    this.skip,
    this.hasMore,
  });

  ChatData.fromJson(Map<String, dynamic> json) {
    if (json['threads'] != null) {
      threads = <Thread>[];
      json['threads'].forEach((v) {
        threads!.add(Thread.fromJson(v));
      });
    }
    total = json['total'];
    limit = json['limit'];
    skip = json['skip'];
    hasMore = json['hasMore'];
  }

  Map<String, dynamic> toJson() {
    return {
      'threads': threads?.map((e) => e.toJson()).toList(),
      'total': total,
      'limit': limit,
      'skip': skip,
      'hasMore': hasMore,
    };
  }
}

class Thread {
  String? id;
  Participant? participant;
  LastMessage? lastMessage;
  String? lastMessageAt;
  int? unreadCount;
  bool? isArchived;
  bool? isPinned;
  bool? isBlocked;
  String? createdAt;
  String? updatedAt;

  Thread({
    this.id,
    this.participant,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount,
    this.isArchived,
    this.isPinned,
    this.isBlocked,
    this.createdAt,
    this.updatedAt,
  });

  Thread.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    participant = json['participant'] != null
        ? Participant.fromJson(json['participant'])
        : null;
    lastMessage = json['lastMessage'] != null
        ? LastMessage.fromJson(json['lastMessage'])
        : null;
    lastMessageAt = json['lastMessageAt'];
    unreadCount = json['unreadCount'];
    isArchived = json['isArchived'];
    isPinned = json['isPinned'];
    isBlocked = json['isBlocked'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participant': participant?.toJson(),
      'lastMessage': lastMessage?.toJson(),
      'lastMessageAt': lastMessageAt,
      'unreadCount': unreadCount,
      'isArchived': isArchived,
      'isPinned': isPinned,
      'isBlocked': isBlocked,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Participant {
  String? id;
  String? firstName;
  String? lastName;
  String? avatar;
  String? profileImage;
  String? username;
  bool? isOnline;

  Participant({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.profileImage,
    this.username,
    this.isOnline,
  });

  Participant.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    avatar = json['avatar'];
    profileImage = json['profileImage'];
    username = json['username'];
    isOnline = json['isOnline'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'profileImage': profileImage,
      'username': username,
      'isOnline': isOnline,
    };
  }
}

class LastMessage {
  String? text;
  List<dynamic>? media;
  String? createdAt;
  Sender? senderId;
  bool? isDeleted;

  LastMessage({
    this.text,
    this.media,
    this.createdAt,
    this.senderId,
    this.isDeleted,
  });

  LastMessage.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    media = json['media'];
    createdAt = json['createdAt'];
    senderId = json['senderId'] != null
        ? Sender.fromJson(json['senderId'])
        : null;
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'media': media,
      'createdAt': createdAt,
      'senderId': senderId?.toJson(),
      'isDeleted': isDeleted,
    };
  }
}

class Sender {
  String? id;
  String? firstName;
  String? lastName;
  String? avatar;
  String? profileImage;
  String? username;

  Sender({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.profileImage,
    this.username,
  });

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    avatar = json['avatar'];
    profileImage = json['profileImage'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'profileImage': profileImage,
      'username': username,
    };
  }
}