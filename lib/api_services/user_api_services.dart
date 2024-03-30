import 'dart:convert';
import 'dart:io';
import 'package:crm/controllers/auth.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void handleLogout(AuthController authController) async {
  try {
    // authController.logout();
    final response = await http.post(
        Uri.parse('${dotenv.env['API_BASE_URL']}token/logout/'),
        headers: {'Authorization': 'Token ${authController.token}'});
    if (response.statusCode == 204) {
      //Success
      authController.logout();
      Get.offAllNamed(RoutesUrls.loginPage);
      print("Logged out!");
    } else {
      //Failed
      throw Exception('Failed to logout: ${response.statusCode}');
    }
  } on SocketException {
    // Handle SocketException: No internet connection or server not reachable
    _showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Failed to logout!");
    print(e);
  }
}

void handleLogin(
    AuthController authController, String? username, String? password) async {
  // Replace with your own logic for validating the username and password
  print("Logging in...");
  try {
    final response = await http
        .post(Uri.parse('${dotenv.env['API_BASE_URL']}token/login/'), body: {
      'username': username,
      'password': password,
    }).timeout(const Duration(seconds: 3), onTimeout: () {
      return http.Response('Error', 408);
    });
    //SUCCESS
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      // print(responseBody);
      getUserFromToken(responseBody['auth_token'], authController);
      // Navigate to home screen or perform any other actions
    } else if (response.statusCode == 408) {
      _showFailureDialog('Request timed out. Please try again.');
    } else {
      // Handle HTTP errors
      throw Exception('Failed to login: ${response.statusCode}');
    }
  } on SocketException {
    // Handle SocketException: No internet connection or server not reachable
    _showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred:");
    _showFailureDialog('Invalid username or password. Please try again.');
  }
}

void getUserFromToken(String token, AuthController authController) async {
  try {
    final response = await http
        .get(Uri.parse('${dotenv.env['API_BASE_URL']}user/me/'), headers: {
      // 'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token'
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody);
      authController.login(token, responseBody);
      Get.offAllNamed(RoutesUrls.homePage);
      Get.snackbar(
        'Success!',
        'You have logged in successfuly to your account.',
        backgroundColor: const Color.fromARGB(255, 71, 120, 73),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2), // Set duration
      );
      print('login success');
    } else {
      throw Exception('Failed to get user: ${response.statusCode}');
    }
  } on SocketException {
    // Handle SocketException: No internet connection or server not reachable
    _showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print('error getting user');
    _showFailureDialog('Invalid username or password. Please try again.');
  }
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
