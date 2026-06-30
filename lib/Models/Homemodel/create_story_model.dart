class CreateStoryResponseModel {
  final int statusCode;
  final bool success;
  final String message;
  final CreateStoryDataModel? data;

  CreateStoryResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    this.data,
  });

  factory CreateStoryResponseModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    }

    return CreateStoryResponseModel(
      statusCode: parseInt(json['statusCode']),
      success: parseBool(json['success']),
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? CreateStoryDataModel.fromJson(json['data']) : null,
    );
  }
}

class CreateStoryDataModel {
  final String id;
  final String userId;
  final String caption;
  final String mediaUrl;
  final String mediaType;
  final String createdAt;
  final String updatedAt;

  CreateStoryDataModel({
    required this.id,
    required this.userId,
    required this.caption,
    required this.mediaUrl,
    required this.mediaType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreateStoryDataModel.fromJson(Map<String, dynamic> json) {
    return CreateStoryDataModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['user']?.toString() ?? json['user_id']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      mediaUrl: json['mediaUrl']?.toString() ?? json['url']?.toString() ?? '',
      mediaType: json['mediaType']?.toString() ?? json['type']?.toString() ?? 'image',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}
