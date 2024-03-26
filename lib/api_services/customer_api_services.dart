import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<bool> createCustomer({
  required String firstName,
  required String lastName,
  required String address,
  required String phoneNumber,
  required String token,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_BASE_URL']}customers/'),
      headers: {'Authorization': 'Token $token'},
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'address': address,
        'phone_number': phoneNumber,
      },
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      return http.Response('Error', 408);
    });

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 408) {
      Get.snackbar(
        'Error',
        'Request timed out. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to create customer: ${response.statusCode}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  } catch (e) {
    print("Error occurred: $e");
    Get.snackbar(
      'Error',
      'Failed to create customer. Please try again.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  return false;
}

Future<bool> handleDeleteCustomer(String token, int customerId) async {
  try {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_BASE_URL']}customers/$customerId/'),
      headers: {'Authorization': 'Token $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      print("successfuly deleted customer $customerId");
      return true;
    } else {
      Get.snackbar(
        'Error',
        'Failed to delete customer. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  } catch (e) {
    print("Error occurred: $e");
    Get.snackbar(
      'Error',
      'Failed to delete customer. Please try again.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  return false;
}

Future<bool> deleteServiceFromCustomer(
    String token, int customerId, int serviceId) async {
  try {
    final response = await http.patch(
      Uri.parse(
          '${dotenv.env['API_BASE_URL']}customers/$customerId/remove-service/$serviceId/'),
      headers: {'Authorization': 'Token ${token}'},
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Customer Service successfuly deleted!',
        backgroundColor: const Color.fromARGB(255, 71, 120, 73),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return true;
    } else if (response.statusCode == 408) {
      Get.snackbar(
        'Error',
        'Request timed out. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to remove service from customer: ${response.statusCode}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  } catch (e) {
    print("Error occurred: $e");
    Get.snackbar(
      'Error',
      'Failed to remove service from customer. Please try again.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  return false;
}

Future<bool> addServiceToCustomer(
    String token, int customerId, int serviceId) async {
  try {
    final response = await http.put(
      Uri.parse(
          '${dotenv.env['API_BASE_URL']}customers/$customerId/add-service/$serviceId/'),
      headers: {'Authorization': 'Token ${token}'},
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Service successfuly added to customer!',
        backgroundColor: const Color.fromARGB(255, 71, 120, 73),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return true;
    } else if (response.statusCode == 408) {
      Get.snackbar(
        'Error',
        'Request timed out. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to add service to customer: ${response.statusCode}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  } catch (e) {
    print("Error occurred: $e");
    Get.snackbar(
      'Error',
      'Failed to add service to customer. Please try again.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  return false;
}
