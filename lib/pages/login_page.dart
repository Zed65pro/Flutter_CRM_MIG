// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final AuthController authController = Get.find();
  final RxString usernameController = ''.obs;
  final RxString passwordController = ''.obs;

  @override
  Widget build(BuildContext context) {
    if (authController.isAuthenticated) {
      return HomePage();
    }
    print(
        "Login Screen: Authenticated Status ${authController.isAuthenticated}");
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 10, 186, 101),
              Color.fromARGB(199, 160, 8, 187),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: loginForm(),
          ),
        ),
      ),
    );
  }

  Card loginForm() {
    return Card(
      elevation: 16.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24.0),
            TextField(
              onChanged: (value) => usernameController.value = value,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: (value) => passwordController.value = value,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _handleLogin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar loginAppbar() {
    return AppBar(
      backgroundColor:
          const Color.fromARGB(255, 221, 204, 204), // Set the background color
      elevation: 10.0, // Remove the shadow
      title: const Row(
        children: [
          // SizedBox(width: 8.0),
          Text(
            'Customer Relation Manager',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.settings), // Add an icon button for settings
      //     onPressed: () {
      //       // Handle settings action
      //     },
      //   ),
      // ],
    );
  }

  void _handleLogin() async {
    // Replace with your own logic for validating the username and password
    print("Logging in...");
    try {
      final response = await http
          .post(Uri.parse('${dotenv.env['API_BASE_URL']}token/login/'), body: {
        'username': usernameController.value,
        'password': passwordController.value,
      });

      //SUCCESS
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print(responseBody);
        getUserFromToken(responseBody['auth_token']);
        print("Token gotten successfuly!");
        // Navigate to home screen or perform any other actions
      } else {
        // Handle HTTP errors
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred:");
      _showFailureDialog();
    }
  }

  void getUserFromToken(String? authToken) async {
    try {
      if (authToken == null) {
        throw Exception('No token provided');
      }
      final response = await http
          .get(Uri.parse('${dotenv.env['API_BASE_URL']}user/me/'), headers: {
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $authToken'
      });

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print(responseBody);
        authController.login(authToken, responseBody);
        Get.offAllNamed(RoutesUrls.homePage);
        print('login success');
      } else {
        throw Exception('Failed to get user: ${response.statusCode}');
      }
    } catch (e) {
      print('error getting user');
      _showFailureDialog();
    }
  }
}

void _showFailureDialog() {
  Get.defaultDialog(
    title: 'Login Failed',
    content: const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Invalid username or password. Please try again.',
        textAlign: TextAlign.center,
      ),
    ),
    textConfirm: 'OK',
    onConfirm: () => Get.back(), // Close the dialog
  );
}
