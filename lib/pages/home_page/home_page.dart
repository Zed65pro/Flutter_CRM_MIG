import 'package:firstapp/api_services/user_api_services.dart';
import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/pages/home_page/components/nav_bar.dart';
import 'package:firstapp/pages/home_page/components/home_appbar.dart';
import 'package:firstapp/pages/home_page/components/home_features.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    print(Get.routing.current);
    debugPrint("Home Screen: Authenticated  ${authController.isAuthenticated}");
    Map<dynamic, dynamic> user = authController.user;
    return Scaffold(
      drawer: Navbar(),
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(children: [
                const TextSpan(
                  text: 'Welcome, ',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                TextSpan(
                  text: '${user['username']}',
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(197, 38, 0, 255),
                  ),
                ),
              ])),
              const SizedBox(height: 16.0),
              const Text(
                'Our powerful Customer Relationship Management (CRM) system helps you manage your customer interactions, streamline processes, and drive business growth. With intuitive features and real-time data analysis, you can enhance customer satisfaction and increase productivity.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 24.0),
              HomeFeatures(authController: authController),
              const SizedBox(height: 24.0),
              const Divider(),
              Column(
                children: [
                  const Text(
                    'Latest features:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RoutesUrls.displayMap);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(
                                255, 219, 50, 78)), // Set the background color
                      ),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Map',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Icon(Icons.location_on)
                          ])),
                ],
              ),
              const SizedBox(height: 24.0),
              const Divider(),
              Row(
                children: [
                  const SizedBox(
                      height:
                          16.0), // Removed 'const' as SizedBox doesn't take 'const' parameter
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        handleLogout(authController);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 219, 50,
                            78), // Use 'primary' for background color
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
