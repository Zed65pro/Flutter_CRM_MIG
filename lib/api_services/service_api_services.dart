import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<bool> handleCreateService({
  required String name,
  required String description,
  required String price,
  required String durationMonths,
  required String token,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_BASE_URL']}services/'),
      headers: {'Authorization': 'Token $token'},
      body: {
        'name': name,
        'description': description,
        'price': price,
        'duration_months': durationMonths,
      },
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      return http.Response('Error', 408);
    });
    final responseBody = json.decode(response.body);
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
        // 'Failed to create service: ${response.statusCode}',
        responseBody['name']
            .toString()
            .replaceAll(r'[', '')
            .replaceAll(']', ''),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  } on SocketException {
    // Handle SocketException: No internet connection or server not reachable
    _showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    Get.snackbar(
      'Error',
      'Failed to create service. Please try again.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  return false;
}

Future<dynamic> handleUpdateService(
    {required String name,
    required String description,
    required String price,
    required String durationMonths,
    required String token,
    required int serviceId}) async {
  try {
    final response = await http.put(
      Uri.parse('${dotenv.env['API_BASE_URL']}services/$serviceId/'),
      headers: {'Authorization': 'Token $token'},
      body: {
        'name': name,
        'description': description,
        'price': price,
        'duration_months': durationMonths,
      },
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
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
        'Failed to edit service: ${response.statusCode}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  } on SocketException {
    // Handle SocketException: No internet connection or server not reachable
    _showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    Get.snackbar(
      'Error',
      'Failed to create service. Please try again.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  return false;
}

Future<bool> handleDeleteService(String token, int serviceId) async {
  print('${dotenv.env['API_BASE_URL']}services/$serviceId/');
  try {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_BASE_URL']}services/$serviceId/'),
      headers: {'Authorization': 'Token $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      Get.snackbar(
        'Success',
        'Service successfully deleted!',
        backgroundColor: const Color.fromARGB(255, 71, 120, 73),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      print("successfuly deleted service $serviceId");
      return true;
    } else {
      Get.snackbar(
        'Error',
        'Failed to delete service. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  } on SocketException {
    // Handle SocketException: No internet connection or server not reachable
    _showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    Get.snackbar(
      'Error',
      'Failed to delete service. Please try again.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  return false;
}

void _showFailureDialog(String msg) {
  Get.defaultDialog(
    title: 'Error',
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        msg,
        textAlign: TextAlign.center,
      ),
    ),
    textConfirm: 'OK',
    onConfirm: () => Get.back(), // Close the dialog
  );
}
