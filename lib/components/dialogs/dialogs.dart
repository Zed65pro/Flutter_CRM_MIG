import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showFailureDialog(String message) {
  Get.defaultDialog(
    title: 'Error',
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
    textConfirm: 'OK',
    onConfirm: () => Get.back(),
  );
}

void showErrorSnackbar(String message) {
  Get.snackbar(
    'Error',
    message,
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
  );
}

void showSuccessSnackbar(String message) {
  Get.snackbar(
    'Success',
    message,
    backgroundColor: const Color.fromARGB(255, 71, 120, 73),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
  );
}
