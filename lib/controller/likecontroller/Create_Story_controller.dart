import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:click_me/data/services/repository/auth repository/create_stroy_repo.dart';
import 'package:click_me/view/utils/Utils.dart';

class CreateStoryController extends GetxController {
  static CreateStoryController get instance => Get.find();

  final _repository = CreateStoryRepository();
  final picker = ImagePicker();

  // Selected mode state ('Story', 'Reel', 'Live')
  final selectedMode = 'Story'.obs;
  final isLoading = false.obs;

  // The picked file state
  final pickedFile = Rx<File?>(null);

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
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image != null) {
        pickedFile.value = File(image.path);
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
        Get.back();
      } else {
        Utils().toastmessage(response.message.isNotEmpty ? response.message : "Failed to post story");
      }
    } catch (e) {
      Utils().toastmessage("Failed to upload story: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
