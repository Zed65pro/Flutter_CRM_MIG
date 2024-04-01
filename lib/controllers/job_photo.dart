import 'package:crm/api_services/job_order_api_services.dart';
import 'package:crm/controllers/job_order.dart';
import 'package:crm/models/job_order_image.dart';
import 'package:get/get.dart';

class JobPhotoController extends GetxController {
  RxString photoPath = ''.obs;
  final JobOrderController jobOrderController = Get.find();

  Future<void> addPhoto(String path, int jobId, String token) async {
    final result =
        await addJobOrderImage(jobId: jobId, imagePath: path, token: token);
    if (result != false) {
      jobOrderController
          .updateFields(jobId, {'images': JobOrderImage.fromJson(result)});
      jobOrderController
          .updateFieldsSelectedJob({'images': JobOrderImage.fromJson(result)});
    }
    photoPath.value = path;
  }
}
