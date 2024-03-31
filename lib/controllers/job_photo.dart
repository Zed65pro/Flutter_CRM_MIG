import 'package:crm/api_services/job_order_api_services.dart';
import 'package:crm/controllers/job_order.dart';
import 'package:get/get.dart';

class JobPhotoController extends GetxController {
  RxString photoPath = ''.obs;
  final JobOrderController jobOrderController = Get.find();

  Future<void> addPhoto(String path, int jobId, String token) async {
    print('$jobId $token $path');
    final result =
        await addJobOrderImage(jobId: jobId, imagePath: path, token: token);
    print(result);
    if (result != false) {
      print('hoooray');
      // jobOrderController.updateFields(jobId, {'images':});
    }
    photoPath.value = path;
  }
}
