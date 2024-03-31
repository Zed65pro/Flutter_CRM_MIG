import 'package:crm/api_services/job_order_api_services.dart';
import 'package:crm/components/dialogs/dialogs.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/models/job_order.dart';
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
  final AuthController authController = Get.find();

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
          authController.token, query.text, currentPage, pageSize);
      print(results);
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
              jobOrders[jobOrderIndex].images.add(value as JobOrderImage);
            default:
              throw Exception('Invalid field name: $key');
          }
        });
      } else {
        throw Exception('Job order with ID $id not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update fields: $e');
    }
  }

  Future<void> addJobOrder(JobOrder jobOrder) async {
    jobOrders.add(jobOrder);
  }
}
