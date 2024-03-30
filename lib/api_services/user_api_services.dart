// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:crm/components/dialogs/dialogs.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

const int DEFAULT_TIMEOUT_SECONDS = 5;

void handleLogout(AuthController authController) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}token/logout/');
    String authToken = 'Token ${authController.token}';
    final response = await http
        .post(url, headers: {'Authorization': authToken}).timeout(
            const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });

    if (response.statusCode == 204) {
      authController.logout();
      Get.offAllNamed(RoutesUrls.loginPage);
      showSuccessSnackbar('Successfuly logged out');
    } else if (response.statusCode == 408) {
      showFailureDialog('Request timed out. Please try again.');
    } else {
      showFailureDialog('Failed to logout: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Failed to logout! $e");
    showFailureDialog('Failed to logiut');
  }
}

void handleLogin(
    AuthController authController, String? username, String? password) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}token/login/');
    Object body = {
      'username': username,
      'password': password,
    };

    final response = await http.post(url, body: body).timeout(
        const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      getUserFromToken(responseBody['auth_token'], authController);
    } else if (response.statusCode == 408) {
      showFailureDialog('Request timed out. Please try again.');
    } else {
      showFailureDialog('Failed to login: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred:");
    showFailureDialog('Invalid username or password. Please try again.');
  }
}

void getUserFromToken(String token, AuthController authController) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}user/me/');
    String authToken = 'Token $token';
    final response = await http
        .get(url, headers: {'Authorization': authToken}).timeout(
            const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody);
      authController.login(token, responseBody);
      Get.offAllNamed(RoutesUrls.homePage);
      showSuccessSnackbar('You have logged in successfuly to your account.');
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showFailureDialog('Failed to get user: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print('error getting user $e');
    showFailureDialog('Invalid username or password. Please try again.');
  }
}
