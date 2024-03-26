import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  final AuthController authController = Get.find();

  @override
  void onReady() {
    super.onReady();
    // Check loading status
    ever(authController.loading, (loading) {
      if (!loading) {
        // If loading is complete, check authentication status
        if (authController.isAuthenticated) {
          // Navigate to home page if authenticated
          Get.offAllNamed(RoutesUrls.homePage);
        } else {
          // Navigate to login page if not authenticated
          Get.offAllNamed(RoutesUrls.loginPage);
        }
      }
    });
  }
}

class SplashScreen extends StatelessWidget {
  final SplashScreenController splashScreenController =
      Get.put(SplashScreenController());

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
