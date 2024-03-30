import 'package:get/get.dart';

class JobPhotoController extends GetxController {
  RxString photoPath = ''.obs;

  void updatePhoto(String path) {
    photoPath.value = path;
  }
}
