import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/pages/appbar/appbar.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    debugPrint("Home Screen: Authenticated  ${authController.isAuthenticated}");
    Map<dynamic, dynamic> user = authController.user;
    return Scaffold(
      appBar: CustomAppBar(
        onMenuSelected: (int index) {
          // Handle menu item selection
          switch (index) {
            case 0:
              Get.offAllNamed(RoutesUrls.loginPage);
              // Handle Customers
              break;
            case 1:
              // Handle Services
              Get.toNamed(RoutesUrls.servicesPage);
              break;
            case 2:
              // Handle Logout
              handleLogout();
              break;
            default:
              break;
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to CRM, ${user['username']}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Our powerful Customer Relationship Management (CRM) system helps you manage your customer interactions, streamline processes, and drive business growth. With intuitive features and real-time data analysis, you can enhance customer satisfaction and increase productivity.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 24.0),
              Column(
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // print("Clicked About: ${user['username']}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                          child: const Text(
                            'Customers',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to Feature 2
                            Get.toNamed(RoutesUrls.servicesPage);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            // padding: const EdgeInsets.symmetric(
                            //   horizontal: 24.0,
                            //   vertical: 16.0,
                            // ),
                          ),
                          child: const Text(
                            'Services',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            handleLogout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            // padding: const EdgeInsets.symmetric(
                            //   horizontal: 24.0,
                            //   vertical: 16.0,
                            // ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleLogout() async {
    final String authToken = authController.token;
    try {
      final response = await http.post(
          Uri.parse('${dotenv.env['API_BASE_URL']}token/logout/'),
          headers: {
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $authToken'
          });
      if (response.statusCode == 204) {
        //Success
        authController.logout();
        Get.offAllNamed(RoutesUrls.loginPage);
        print("Logged out!");
      } else {
        //Failed
        throw Exception('Failed to logout: ${response.statusCode}');
      }
    } catch (e) {
      print("Failed to logout!");
      print(e);
    }
  }
}
