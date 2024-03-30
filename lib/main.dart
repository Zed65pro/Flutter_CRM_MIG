// main.dart
import 'package:crm/controllers/auth.dart';
import 'package:crm/controllers/location.dart';
import 'package:crm/routes.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:crm/settings/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CRM',
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      initialRoute:
          RoutesUrls.splashScreen, // Set the initial route to the LoginPage
      getPages: AppRoutes.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(
          AuthController(),
        );
        Get.put(LocationController());
        // Get.lazyPut(() => LocationController());
      }),
    );
  }
}
