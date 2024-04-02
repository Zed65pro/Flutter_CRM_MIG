import 'package:crm/api/user_api_services.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/components/appbar/profile_picture.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Navbar extends StatelessWidget {
  Navbar({super.key});
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final String username = authController.user['username'];
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(authController.user['email']),
            currentAccountPicture: ProfilePicture(username: username, size: 70),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 49, 184, 211),
              Color.fromARGB(255, 163, 74, 179)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Add navigation logic here
              if (Get.routing.current != '/home') {
                Get.offAllNamed(RoutesUrls.homePage);
              } else {
                Get.back();
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Customers'),
            onTap: () {
              Get.offAllNamed(RoutesUrls.customersPage,
                  predicate: (route) =>
                      route.settings.name == RoutesUrls.homePage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_repair_service),
            title: const Text('Services'),
            onTap: () {
              Get.offAllNamed(RoutesUrls.servicesPage,
                  predicate: (route) =>
                      route.settings.name == RoutesUrls.homePage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Add a customer'),
            onTap: () {
              Get.offAllNamed(RoutesUrls.createCustomer,
                  predicate: (route) =>
                      route.settings.name == RoutesUrls.homePage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add a service'),
            trailing: const Icon(Icons.admin_panel_settings),
            onTap: () {
              if (!authController.user['is_staff']) {
                Get.defaultDialog(
                  title: "Access Denied",
                  middleText:
                      "You are trying to access a route for admins only.",
                  textConfirm: "OK",
                  onConfirm: () {
                    Get.back(); // Close the dialog
                  },
                );
              } else {
                Get.offAllNamed(RoutesUrls.createService,
                    predicate: (route) =>
                        route.settings.name == RoutesUrls.homePage);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              handleLogout(authController);
            },
          ),
        ],
      ),
    );
  }
}
