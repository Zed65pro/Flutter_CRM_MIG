import 'package:crm/api_services/job_order_api_services.dart';
import 'package:crm/components/dialogs/dialogs.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/models/job_order.dart';
import 'package:crm/models/job_order_comment.dart';
import 'package:crm/models/job_order_image.dart';
import 'package:crm/models/point.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobOrderController extends GetxController {
  final RxList<JobOrder> jobOrders = <JobOrder>[].obs;
  final RxBool _isLoading = false.obs;
  final RxInt _currentPage = 1.obs;
  final RxInt _count = 0.obs;
  final RxInt _pageSize = 6.obs; // Number of items per page
  final TextEditingController query = TextEditingController();
  final RxList filterList = [].obs;
  final AuthController authController = Get.find();
  final Rx<JobOrder?> selectedJobOrder = Rx<JobOrder?>(null);

  bool get isLoading => _isLoading.value;
  set isLoading(bool val) => _isLoading.value = val;
  int get currentPage => _currentPage.value;
  set currentPage(int val) => _currentPage.value = val;
  int get count => _count.value;
  set count(int val) => _count.value = val;
  int get pageSize => _pageSize.value;
  set pageSize(int val) => _pageSize.value = val;

  @override
  void onInit() {
    super.onInit();
    fetchJobOrders();
  }

  Future<void> fetchJobOrders() async {
    isLoading = true;
    try {
      final results = await fetchJobOrdersApi(
          authController.token, query.text, currentPage, pageSize, filterList);

      if (results != null) {
        if (results[0].isEmpty) {
          jobOrders.clear();
        } else {
          jobOrders.assignAll(results[0]);
        }
        count = results[1];
        currentPage = results[2];
      }
    } catch (e) {
      showFailureDialog('Failed to fetch job orders: $e');
      print("error $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> updateFieldsSelectedJob(
      Map<String, dynamic> fieldsToUpdate) async {
    try {
      if (selectedJobOrder != null) {
        fieldsToUpdate.forEach((key, value) {
          switch (key) {
            case 'name':
              selectedJobOrder.value?.name = value as String;
              break;
            case 'description':
              selectedJobOrder.value?.description = value as String;
              break;
            case 'area':
              selectedJobOrder.value?.area = value as String;
              break;
            case 'city':
              selectedJobOrder.value?.city = value as String;
              break;
            case 'street':
              selectedJobOrder.value?.street = value as String;
              break;
            case 'phone_number':
              selectedJobOrder.value?.phoneNumber = value as String;
              break;
            case 'email':
              selectedJobOrder.value?.email = value as String;
              break;
            case 'feedback':
              selectedJobOrder.value?.feedback = value as String;
              break;
            case 'status':
              selectedJobOrder.value?.status = value as String;
              break;
            case 'location':
              selectedJobOrder.value?.location = value as Point;
              break;
            case 'images':
              selectedJobOrder.value?.images.insert(0, value as JobOrderImage);
              break;
            case 'comments':
              selectedJobOrder.value?.comments
                  .insert(0, value as JobOrderComment);
              break;
            default:
              throw Exception('Invalid field name: $key');
          }
          update();
        });
      } else {
        throw Exception('big faillll');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateFields(int id, Map<String, dynamic> fieldsToUpdate) async {
    try {
      var jobOrderIndex = jobOrders.indexWhere((order) => order.id == id);
      if (jobOrderIndex != -1) {
        fieldsToUpdate.forEach((key, value) {
          switch (key) {
            case 'name':
              jobOrders[jobOrderIndex].name = value as String;
              break;
            case 'description':
              jobOrders[jobOrderIndex].description = value as String;
              break;
            case 'area':
              jobOrders[jobOrderIndex].area = value as String;
              break;
            case 'city':
              jobOrders[jobOrderIndex].city = value as String;
              break;
            case 'street':
              jobOrders[jobOrderIndex].street = value as String;
              break;
            case 'phone_number':
              jobOrders[jobOrderIndex].phoneNumber = value as String;
              break;
            case 'email':
              jobOrders[jobOrderIndex].email = value as String;
              break;
            case 'feedback':
              jobOrders[jobOrderIndex].feedback = value as String;
              break;
            case 'status':
              jobOrders[jobOrderIndex].status = value as String;
              break;
            case 'location':
              jobOrders[jobOrderIndex].location = value as Point;
            case 'images':
              jobOrders[jobOrderIndex].images.insert(0, value as JobOrderImage);
            case 'comments':
              selectedJobOrder.value?.comments
                  .insert(0, value as JobOrderComment);
            default:
              throw Exception('Invalid field name: $key');
          }
        });
      } else {
        throw Exception('Job order with ID $id not found');
      }
    } catch (e) {
      print(e);
      // Get.snackbar('Error', 'Failed to update fields: $e');
    }
  }

  Future<void> addJobOrder(JobOrder jobOrder) async {
    jobOrders.add(jobOrder);
  }

  Future<dynamic> addComment(
      int jobId, String token, String body, JobOrder jobOrder) async {
    final result =
        await addJobOrderComment(jobId: jobId, body: body, token: token);
    if (result != false) {
      // return result;
      // List<JobOrderComment> copiedList =
      //     List<JobOrderComment>.from(jobOrder.comments);
      // copiedList.insert(0, JobOrderComment.fromJson(result));
      // selectedJobOrder.value?.comments = copiedList;
      // updatedJobOrder.comments
      // updateFields(jobId, {'comments': JobOrderComment.fromJson(result)});
      updateFieldsSelectedJob({'comments': JobOrderComment.fromJson(result)});
    }
  }

  Future<void> addFeedback(
      int jobId, String token, String feedback, JobOrder jobOrder) async {
    JobOrder updatedJobOrder = jobOrder.copy();
    updatedJobOrder.feedback = feedback;

    final result = await updateJobOrder(
        jobId: jobId, token: token, updatedJobOrder: updatedJobOrder);
    print(result);

    if (result != false) {
      updateFields(jobId, {'feedback': result['feedback']});
      updateFieldsSelectedJob({'feedback': result['feedback']});
    }
  }

  // Future<void> addUpdateFieldFromView(
  //   int jobId,
  //   String token,
  //   Map<String, dynamic> fieldsToUpdate,
  //   JobOrder jobOrder,
  // ) async {
  //   // Create a copy of the original jobOrder
  //   JobOrder updatedJobOrder = jobOrder.copy();

  //   // Update fields in the updatedJobOrder
  //   fieldsToUpdate.forEach((key, value) {
  //     switch (key) {
  //       case 'name':
  //         updatedJobOrder.name = value as String;
  //         break;
  //       case 'description':
  //         updatedJobOrder.description = value as String;
  //         break;
  //       case 'area':
  //         updatedJobOrder.area = value as String;
  //         break;
  //       case 'city':
  //         updatedJobOrder.city = value as String;
  //         break;
  //       case 'street':
  //         updatedJobOrder.street = value as String;
  //         break;
  //       case 'phoneNumber':
  //         updatedJobOrder.phoneNumber = value as String;
  //         break;
  //       case 'email':
  //         updatedJobOrder.email = value as String;
  //         break;
  //       case 'location':
  //         updatedJobOrder.location = value as Point;
  //         break;
  //       case 'feedback':
  //         updatedJobOrder.feedback = value as String;
  //         break;
  //       case 'status':
  //         updatedJobOrder.status = value as String;
  //         break;
  //       // Add cases for other fields if needed
  //       default:
  //         // Handle unknown fields or ignore them
  //         print('Unknown field: $key');
  //         break;
  //     }
  //   });

  //   // Call the method to update the job order with the updated fields
  //   final result = await updateJobOrder(
  //     jobId: jobId,
  //     token: token,
  //     updatedJobOrder: updatedJobOrder,
  //   );

  //   print(result);
  // }
}
