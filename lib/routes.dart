// routes.dart
import 'package:crm/pages/job_order_details/components/job_details_camera.dart';
import 'package:crm/pages/job_order_details/job_order_details_page.dart';
import 'package:crm/pages/job_orders/components/job_camera.dart';
import 'package:crm/pages/create_customer/create_customer.dart';
import 'package:crm/pages/create_service/create_service.dart';
import 'package:crm/pages/customer_details/customer_details.dart';
import 'package:crm/pages/customers/customers_page.dart';
import 'package:crm/pages/edit_customer/edit_customer.dart';
import 'package:crm/pages/edit_service/edit_service.dart';
import 'package:crm/pages/home_page/home_page.dart';
import 'package:crm/middlewares/auth.dart';
import 'package:crm/pages/job_orders/job_orders_page.dart';
import 'package:crm/pages/login_page/login_page.dart';
import 'package:crm/pages/map/direction_map.dart';
import 'package:crm/pages/service_details/service_details.dart';
import 'package:crm/pages/services/services_page.dart';
import 'package:crm/splash_screen.dart';
import 'package:get/get.dart';
import 'package:crm/settings/routes_urls.dart';

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
      page: () => const JobDetailsCamera(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer create page
      name: RoutesUrls.jobOrder,
      page: () => const JobOrderPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      //Customer create page
      name: RoutesUrls.jobOrderDetails,
      page: () => const JobOrderDetails(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
