import 'dart:async';
import 'dart:convert';

import 'package:click_me/Models/live_model/startlive_model.dart';
import 'package:click_me/services/liveservices/startlive_services.dart';
import 'package:click_me/services/liveservices/endlive_services.dart';
import 'package:click_me/services/webrtc_signaling.dart';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StartLiveController extends GetxController {
  final isLoading = false.obs;
  final liveData = Rxn<LiveStreamData>();
  final comments = <LiveComment>[].obs;
  Timer? _commentsTimer;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final _service = StartLiveService();
  final _endService = EndLiveService();

  // WebRTC fields
  final signaling = WebRTCSignaling();
  final localRenderer = RTCVideoRenderer();
  final isCameraInitialized = false.obs;
  final isCameraPermissionDenied = false.obs;
  bool _isInitializingCamera = false;

  // Filter fields
  final showFilters = false.obs;
  final selectedFilterIndex = 0.obs;

  // Filter definitions
  static const List<Map<String, dynamic>> filters = [
    {
      'name': 'Normal',
      'colors': [Colors.white70, Colors.white],
      'matrix': null,
    },
    {
      'name': 'Chrome',
      'colors': [Color(0xFF90CAF9), Color(0xFFE0F7FA)],
      'matrix': [
        0.8,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.25,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
      ],
    },
    {
      'name': 'B&W',
      'colors': [Color(0xFF424242), Color(0xFFBDBDBD)],
      'matrix': [
        0.2126,
        0.7152,
        0.0722,
        0.0,
        0.0,
        0.2126,
        0.7152,
        0.0722,
        0.0,
        0.0,
        0.2126,
        0.7152,
        0.0722,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
      ],
    },
    {
      'name': 'Sepia',
      'colors': [Color(0xFF8B5A2B), Color(0xFFCD853F)],
      'matrix': [
        0.393,
        0.769,
        0.189,
        0.0,
        0.0,
        0.349,
        0.686,
        0.168,
        0.0,
        0.0,
        0.272,
        0.534,
        0.131,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
      ],
    },
    {
      'name': 'Vintage',
      'colors': [Color(0xFFE6A817), Color(0xFF4682B4)],
      'matrix': [
        0.9,
        0.3,
        0.1,
        0.0,
        0.0,
        0.2,
        0.8,
        0.1,
        0.0,
        0.0,
        0.1,
        0.2,
        0.7,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
      ],
    },
    {
      'name': 'Golden',
      'colors': [Color(0xFFFFD700), Color(0xFFFFA500)],
      'matrix': [
        1.2,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.75,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
      ],
    },
    {
      'name': 'Negative',
      'colors': [Colors.black, Colors.white],
      'matrix': [
        -1.0,
        0.0,
        0.0,
        0.0,
        255.0,
        0.0,
        -1.0,
        0.0,
        0.0,
        255.0,
        0.0,
        0.0,
        -1.0,
        0.0,
        255.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
      ],
    },
  ];

  @override
  void onInit() {
    super.onInit();
    localRenderer.initialize().then((_) {
      initCamera();
    });
  }

  Future<void> initCamera() async {
    if (_isInitializingCamera) return;
    if (isCameraInitialized.value && signaling.localStream != null) {
      return;
    }
    _isInitializingCamera = true;
    isCameraInitialized.value = false;
    isCameraPermissionDenied.value = false;
    try {
      final stream = await signaling.createLocalStream().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print("Camera: WebRTC getUserMedia timed out!");
          throw Exception("Camera initialization timed out");
        },
      );
      localRenderer.srcObject = stream;
      isCameraInitialized.value = true;
    } catch (e) {
      print("Camera initialization error: $e");
      isCameraPermissionDenied.value = true;
    } finally {
      _isInitializingCamera = false;
    }
  }

  Future<void> switchCamera() async {
    try {
      await signaling.switchCamera();
    } catch (e) {
      print("Error switching camera: $e");
      Utils().toastmessage("Failed to switch camera.");
    }
  }

  Future<bool> startLive() async {
    try {
      isLoading.value = true;

      final result = await _service.startLiveStream(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
      );

      if (result.success == true && result.data != null) {
        liveData.value = result.data;
        startPollingComments();

        // Start WebRTC broadcasting via Firestore signaling
        try {
          await signaling.startBroadcasting(result.data!.id!);
        } catch (e) {
          final msg = e.toString();
          if (msg.contains('permission-denied') ||
              msg.contains('PERMISSION_DENIED')) {
            Utils().toastmessage(
              "Firebase permission denied. Please update Firestore rules in Firebase Console to allow authenticated users.",
            );
          } else {
            Utils().toastmessage("WebRTC signaling error: $msg");
          }
          // Still return true — the backend live stream started, only Firestore signaling failed
        }

        Utils().toastmessage("Live stream started successfully!");
        return true;
      } else {
        Utils().toastmessage(result.message ?? "Failed to start live stream.");
        return false;
      }
    } catch (e) {
      Utils().toastmessage(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> endLive() async {
    final currentStreamId = liveData.value?.id;
    if (currentStreamId == null) {
      Utils().toastmessage("No active live stream found to end.");
      return false;
    }

    stopPollingComments();

    try {
      isLoading.value = true;
      // Clean up WebRTC signaling
      await signaling.cleanUp(currentStreamId);
      localRenderer.srcObject = null;
      isCameraInitialized.value = false;

      final result = await _endService.endLiveStream(currentStreamId);

      if (result.success == true) {
        liveData.value = null; // Clear live stream data
        Utils().toastmessage("Live stream ended successfully!");
        return true;
      } else {
        Utils().toastmessage(result.message ?? "Failed to end live stream.");
        return false;
      }
    } catch (e) {
      Utils().toastmessage(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> disposeCamera() async {
    isCameraInitialized.value = false;
    await signaling.cleanUp(liveData.value?.id);
    localRenderer.srcObject = null;
  }

  @override
  void onClose() {
    stopPollingComments();
    titleController.dispose();
    descriptionController.dispose();
    disposeCamera();
    localRenderer.dispose();
    super.onClose();
  }

  // Live Comments Polling
  void startPollingComments() {
    _commentsTimer?.cancel();
    fetchComments();
    _commentsTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchComments();
    });
  }

  void stopPollingComments() {
    _commentsTimer?.cancel();
    _commentsTimer = null;
  }

  Future<void> fetchComments() async {
    final streamId = liveData.value?.id;
    if (streamId == null) return;

    try {
      final token = StorageService.getAccessToken();
      final response = await http.get(
        Uri.parse("${Api.livecommentsUrl}?liveStreamId=$streamId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> dataList = jsonData['data'];
          final parsedComments =
              dataList.map((item) => LiveComment.fromJson(item)).toList();
          comments.assignAll(parsedComments);
        }
      }
    } catch (e) {
      print("Error fetching live comments: $e");
    }
  }
}

class LiveComment {
  final String id;
  final String liveStreamId;
  final String text;
  final String userId;
  final String firstName;
  final String lastName;
  final String avatar;
  final String username;
  final DateTime createdAt;

  LiveComment({
    required this.id,
    required this.liveStreamId,
    required this.text,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.username,
    required this.createdAt,
  });

  factory LiveComment.fromJson(Map<String, dynamic> json) {
    final userJson = json['userId'] ?? {};
    return LiveComment(
      id: json['_id'] ?? '',
      liveStreamId: json['liveStreamId'] ?? '',
      text: json['text'] ?? '',
      userId: userJson['_id'] ?? '',
      firstName: userJson['firstName'] ?? '',
      lastName: userJson['lastName'] ?? '',
      avatar: userJson['avatar'] ?? '',
      username: userJson['username'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
