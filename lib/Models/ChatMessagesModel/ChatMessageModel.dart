class ChatMessageModel {
  int? statusCode;
  Data? data;
  String? message;
  bool? success;

  ChatMessageModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
    message = json["message"];
    success = json["success"];
  }
}

class Data {
  List<Message>? messages;
  bool? hasMore;
  String? nextCursor;

  Data({
    this.messages,
    this.hasMore,
    this.nextCursor,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json["messages"] != null) {
      messages = <Message>[];

      json["messages"].forEach((v) {
        messages!.add(Message.fromJson(v));
      });
    }

    hasMore = json["hasMore"];
    nextCursor = json["nextCursor"];
  }
}

class Message {
  String? id;
  String? receiverId;
  String? text;
  String? createdAt;

  Sender? senderId;

  Message({
    this.id,
    this.receiverId,
    this.text,
    this.createdAt,
    this.senderId,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    receiverId = json["receiverId"];
    text = json["text"];
    createdAt = json["createdAt"];

    senderId =
        json["senderId"] != null ? Sender.fromJson(json["senderId"]) : null;
  }
}

class Sender {
  String? id;
  String? firstName;
  String? lastName;

  Sender({
    this.id,
    this.firstName,
    this.lastName,
  });

  Sender.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    firstName = json["firstName"];
    lastName = json["lastName"];
  }
}