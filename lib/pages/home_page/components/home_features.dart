import 'package:firstapp/api_services/user_api_services.dart';
import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFeatures extends StatelessWidget {
  HomeFeatures({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  // Define a centralized variable for the button color
  final Color buttonColor = Color.fromARGB(197, 92, 101, 224);

  // Define a list of button data
  final List<Map<String, dynamic>> buttons = [
    {'text': 'Customers', 'route': RoutesUrls.customersPage},
    {'text': 'Services', 'route': RoutesUrls.servicesPage},
    // {'text': 'Logout', 'route': null}, // For logout, handle separately
    {'text': 'Create customer', 'route': RoutesUrls.createCustomer},
    {'text': 'Create Service', 'route': RoutesUrls.createService},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Explore our features:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        // Dynamically generate buttons from the list
        for (final button in buttons)
          _buildButton(button['text'], button['route']),
      ],
    );
  }

  // Function to build a button
  Widget _buildButton(String buttonText, String? route) {
    return Row(
      children: [
        const SizedBox(height: 16.0),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (route != null) {
                Get.toNamed(route);
              } else {
                handleLogout(authController);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
