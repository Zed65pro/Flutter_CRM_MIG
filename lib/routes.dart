// routes.dart
import 'package:firstapp/pages/login_page.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/middlewares/auth.dart';
import 'package:firstapp/pages/service_details/service_details.dart';
import 'package:firstapp/pages/services/services_page.dart';
import 'package:get/get.dart';
import 'package:firstapp/settings/routes_urls.dart';

class AppRoutes {
  static final List<GetPage> routes = [
    GetPage(
      //LOGIN PAGE
      name: RoutesUrls.loginPage,
      page: () => LoginPage(),
    ),
    GetPage(
      // HOME PAGE
      name: RoutesUrls.homePage,
      page: () => HomePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //SERVICES PAGE
      name: RoutesUrls.servicesPage,
      page: () => const ServicesPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RoutesUrls.serviceDetails,
      page: () => const ServiceDetails(),
      middlewares: [AuthMiddleware()],
    )
  ];
}
