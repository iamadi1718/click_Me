import 'package:get/get.dart';

class LikeController extends GetxController {
  RxMap<int, bool> isLiked = <int, bool>{}.obs;
  RxMap<int, int> likes = <int, int>{}.obs;

  void initialize(int index, int count) {
    if (!likes.containsKey(index)) {
      likes[index] = count;
      isLiked[index] = false;
    }
  }

  void toggleLike(int index) {
    if (isLiked[index] == true) {
      isLiked[index] = false;
      likes[index] = likes[index]! - 1;
    } else {
      isLiked[index] = true;
      likes[index] = likes[index]! + 1;
    }
  }
}