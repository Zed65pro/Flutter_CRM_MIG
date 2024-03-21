import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find();
    debugPrint("middleware");
    if (!authController.isAuthenticated) {
      return RouteSettings(name: RoutesUrls.loginPage);
    }
    return null;
  }
}
