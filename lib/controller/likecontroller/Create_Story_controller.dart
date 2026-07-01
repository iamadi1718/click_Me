import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:click_me/data/services/repository/auth repository/create_stroy_repo.dart';
import 'package:click_me/view/utils/Utils.dart';
import 'package:click_me/controller/likecontroller/story_feed_controller.dart';
import 'package:click_me/controller/likecontroller/dashboard_controller.dart';

class CreateStoryController extends GetxController {
  static CreateStoryController get instance => Get.find();

  final _repository = CreateStoryRepository();
  final picker = ImagePicker();

  // Selected mode state ('Story', 'Reel', 'Live')
  final selectedMode = 'Story'.obs;
  final isLoading = false.obs;

  // The picked file state
  final pickedFile = Rx<File?>(null);

  // Camera state fields
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  final isCameraInitialized = false.obs;
  final isCameraPermissionDenied = false.obs;
  bool _isInitializingCamera = false;

  // Change active mode
  void changeMode(String mode) {
    selectedMode.value = mode;
  }

  // Clear picked image
  void clearPickedFile() {
    pickedFile.value = null;
  }

  // Action for Picking from Gallery
  Future<void> pickFromGallery() async {
    try {
      isLoading.value = true;
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        pickedFile.value = File(image.path);
      }
    } catch (e) {
      Utils().toastmessage("Error picking image: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Action for Shutter / Capture Button (takes photo)
  Future<void> captureStory() async {
    try {
      isLoading.value = true;
      if (isCameraInitialized.value && cameraController != null && cameraController!.value.isInitialized) {
        final XFile file = await cameraController!.takePicture();
        pickedFile.value = File(file.path);
      } else {
        // Fallback to ImagePicker if camera fails to initialize
        final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (image != null) {
          pickedFile.value = File(image.path);
        }
      }
    } catch (e) {
      Utils().toastmessage("Error capturing image: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Upload Story to Backend
  Future<void> uploadStory() async {
    if (pickedFile.value == null) {
      Utils().toastmessage("Please select or capture a story first!");
      return;
    }

    try {
      isLoading.value = true;
      
      final response = await _repository.uploadStoryMultipart(
        file: pickedFile.value!,
        caption: "Story shared via clickMe",
        type: selectedMode.value.toLowerCase(), // 'story' or 'reel'
      );

      if (response.success) {
        Utils().toastmessage("Story posted successfully!");
        clearPickedFile();

        // Refresh the story feed reactively
        if (Get.isRegistered<StoryFeedController>()) {
          Get.find<StoryFeedController>().fetchStoryData();
        }

        // Handle navigation correctly depending on context
        final context = Get.context;
        if (context != null && Navigator.canPop(context)) {
          Get.back();
        } else {
          // If we are embedded in the Mediapage tab and cannot pop, switch to Home tab
          if (Get.isRegistered<DashboardController>()) {
            Get.find<DashboardController>().changeIndex(0);
          }
        }
      } else {
        Utils().toastmessage(response.message.isNotEmpty ? response.message : "Failed to post story");
      }
    } catch (e) {
      Utils().toastmessage("Failed to upload story: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Camera Helper Methods
  Future<void> initCamera() async {
    if (_isInitializingCamera) return;
    if (isCameraInitialized.value && cameraController != null && cameraController!.value.isInitialized) {
      return;
    }
    _isInitializingCamera = true;
    isCameraInitialized.value = false;
    isCameraPermissionDenied.value = false;
    try {
      cameras = await availableCameras().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print("Story Camera: availableCameras timed out!");
          return [];
        },
      );
      if (cameras.isNotEmpty) {
        // Use last camera (webcam/front camera) by default for story selfies
        final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.last,
        );

        cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await cameraController!.initialize().timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            print("Story Camera: initialize timed out!");
            throw Exception("Camera initialization timed out");
          },
        );
        isCameraInitialized.value = true;
      } else {
        isCameraPermissionDenied.value = true;
      }
    } catch (e) {
      print("Story Camera initialization error: $e");
      isCameraPermissionDenied.value = true;
    } finally {
      _isInitializingCamera = false;
    }
  }

  Future<void> disposeCamera() async {
    final tempController = cameraController;
    cameraController = null;
    isCameraInitialized.value = false;
    if (tempController != null) {
      try {
        await tempController.dispose();
      } catch (e) {
        print("Story Camera dispose error: $e");
      }
    }
  }

  Future<void> switchCamera() async {
    if (cameras.length < 2 || cameraController == null) return;
    final currentLensDirection = cameraController!.description.lensDirection;
    final newCamera = cameras.firstWhere(
      (camera) => camera.lensDirection != currentLensDirection,
      orElse: () => cameras.first,
    );

    await disposeCamera();

    cameraController = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      print("Story Camera switch error: $e");
    }
  }

  @override
  void onClose() {
    disposeCamera();
    super.onClose();
  }
}
