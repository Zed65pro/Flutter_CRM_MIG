import 'package:crm/api/api_client.dart';
import 'package:crm/models/job_order.dart';
import 'package:crm/models/job_order_comment.dart';
import 'package:crm/models/job_order_image.dart';
import 'package:crm/models/point.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobOrderController extends GetxController {
  final int pageSize = 6;

  final RxList<JobOrder> jobOrders = <JobOrder>[].obs;
  final Rx<JobOrder?> selectedJobOrder = Rx<JobOrder?>(null);
  final RxBool _isLoading = false.obs;
  final RxInt _count = 0.obs;

  final RxInt _currentPage = 1.obs;
  final TextEditingController query = TextEditingController();
  final RxList filterList = [].obs;

  final ApiClient apiClient = Get.find();

  bool get isLoading => _isLoading.value;
  set isLoading(bool val) => _isLoading.value = val;
  int get currentPage => _currentPage.value;
  set currentPage(int val) => _currentPage.value = val;
  int get count => _count.value;
  set count(int val) => _count.value = val;

  @override
  void onInit() {
    fetchJobOrders();
    super.onInit();
  }

  Future<void> updateFieldsSelectedJob(
      Map<String, dynamic> fieldsToUpdate) async {
    try {
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
        selectedJobOrder.refresh();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchJobOrders() async {
    isLoading = true;
    final results = await apiClient.fetchJobOrders(
        search: query.text, currentPage: currentPage, filterList: filterList);

    if (results != null) {
      if (results[0].isEmpty) {
        jobOrders.clear();
      } else {
        jobOrders.assignAll(results[0]);
      }
      count = results[1];
      currentPage = results[2];
      if (selectedJobOrder.value != null) {
        final updatedSelectedItem = jobOrders
            .firstWhere((item) => item.id == selectedJobOrder.value?.id);
        selectedJobOrder.value = updatedSelectedItem;
      }
    }

    isLoading = false;
  }

  Future<void> addComment(int jobId, String token, String body) async {
    isLoading = true;
    final result = await apiClient.addJobOrderComment(jobId: jobId, body: body);
    if (result != null) {
      updateFieldsSelectedJob({'comments': JobOrderComment.fromJson(result)});
    }
    isLoading = false;
  }

  Future<void> addFeedback(int jobId, String token, String feedback) async {
    isLoading = true;
    final result = await apiClient.updateJobOrder(
        jobId: jobId,
        updatedJobOrderJson: {
          ...selectedJobOrder.value!.toUpdateJson(),
          'feedback': feedback
        });

    if (result != null) {
      updateFieldsSelectedJob({'feedback': result['feedback']});
    }
    isLoading = false;
  }

  Future<void> addPhoto(String path, int jobId, String token) async {
    isLoading = true;
    final result =
        await apiClient.addJobOrderImage(jobId: jobId, imagePath: path);
    if (result != null) {
      updateFieldsSelectedJob({'images': JobOrderImage.fromJson(result)});
    }
    isLoading = false;
  }
}
