// routes.dart
import 'package:firstapp/pages/camera/job_camera.dart';
import 'package:firstapp/pages/create_customer/create_customer.dart';
import 'package:firstapp/pages/create_service/create_service.dart';
import 'package:firstapp/pages/customer_details/customer_details.dart';
import 'package:firstapp/pages/customers/customers_page.dart';
import 'package:firstapp/pages/edit_customer/edit_customer.dart';
import 'package:firstapp/pages/edit_service/edit_service.dart';
import 'package:firstapp/pages/home_page/home_page.dart';
import 'package:firstapp/middlewares/auth.dart';
import 'package:firstapp/pages/login_page/login_page.dart';
import 'package:firstapp/pages/map/direction_map.dart';
import 'package:firstapp/pages/service_details/service_details.dart';
import 'package:firstapp/pages/services/services_page.dart';
import 'package:firstapp/splash_screen.dart';
import 'package:get/get.dart';
import 'package:firstapp/settings/routes_urls.dart';

class AppRoutes {
  static final List<GetPage> routes = [
    GetPage(
      //LOGIN PAGE
      name: RoutesUrls.splashScreen,
      page: () => SplashScreen(),
    ),
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
      //Service Detais page
      name: RoutesUrls.serviceDetails,
      page: () => const ServiceDetails(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer PAGE
      name: RoutesUrls.customersPage,
      page: () => const CustomersPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer Detais page
      name: RoutesUrls.customerDetails,
      page: () => const CustomerDetails(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer create page
      name: RoutesUrls.createCustomer,
      page: () => const CreateCustomer(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer create page
      name: RoutesUrls.createService,
      page: () => const CreateService(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer create page
      name: RoutesUrls.updateCustomer,
      page: () => const EditCustomer(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer create page
      name: RoutesUrls.updateService,
      page: () => const EditService(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer create page
      name: RoutesUrls.displayMap,
      page: () => const DirectionMap(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer create page
      name: RoutesUrls.jobCamera,
      page: () => const JobCamera(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
