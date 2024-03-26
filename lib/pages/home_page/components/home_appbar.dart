import 'package:firstapp/api_services/user_api_services.dart';
import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomeAppBar({super.key, this.title = 'Customer relation manager'});
  final String title;

  final AuthController authController = Get.find();

  @override
  Size get preferredSize => const Size.fromHeight(120.0); // Increased height

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 41, 121, 201),
              Color.fromARGB(198, 195, 58, 219),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AppBar(
            leading: Get.routing.current != '/home'
                ? IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white), // Set the color to white
                    onPressed: () {
                      Get.back(); // Navigate back
                    },
                  )
                : null, // Set leading to null if there's no previous route
            elevation: 0,
            backgroundColor: Colors.transparent, // Transparent background
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // PopupMenuButton<int>(
                //   onSelected: onMenuSelected,
                //   icon: const Icon(
                //     Icons.menu,
                //     color: Colors.white,
                //   ),
                //   itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                //     const PopupMenuItem<int>(
                //       value: 0,
                //       child: Text(
                //         'Customers',
                //         style: TextStyle(color: Colors.black87),
                //       ),
                //     ),
                //     const PopupMenuItem<int>(
                //       value: 1,
                //       child: Text(
                //         'Services',
                //         style: TextStyle(color: Colors.black87),
                //       ),
                //     ),
                //     const PopupMenuItem<int>(
                //       value: 2,
                //       child: Text(
                //         'Create Customer',
                //         style: TextStyle(color: Colors.black87),
                //       ),
                //     ),
                //     const PopupMenuItem<int>(
                //       value: 3,
                //       child: Text(
                //         'Create Service',
                //         style: TextStyle(color: Colors.black87),
                //       ),
                //     ),
                //     const PopupMenuItem<int>(
                //       value: 4,
                //       child: Text(
                //         'Logout',
                //         style: TextStyle(color: Colors.black87),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
            iconTheme: const IconThemeData(color: Colors.white)),
      ),
    );
  }

  void onMenuSelected(int index) {
    // Handle menu item selection
    switch (index) {
      case 0:
        Get.offAllNamed(RoutesUrls.customersPage,
            predicate: (route) => route.settings.name == RoutesUrls.homePage);
        // Get.toNamed('/customers_page');
        // Handle Customers
        break;
      case 1:
        // Handle Services
        Get.offAllNamed(RoutesUrls.servicesPage,
            predicate: (route) => route.settings.name == RoutesUrls.homePage);
        // Get.toNamed(RoutesUrls.servicesPage);
        break;
      case 2:
        // Handle customer create
        Get.offAllNamed(RoutesUrls.createCustomer,
            predicate: (route) => route.settings.name == RoutesUrls.homePage);
        // Get.toNamed(RoutesUrls.createCustomer);
        break;
      case 3:
        // Handle Services create
        Get.offAllNamed(RoutesUrls.createService,
            predicate: (route) => route.settings.name == RoutesUrls.homePage);
        // Get.toNamed(RoutesUrls.createService);
        break;
      case 4:
        // Handle Logout
        handleLogout(authController);
        break;

      default:
        break;
    }
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height * 0.9);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height * 0.9,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height * 0.8,
      size.width,
      size.height * 0.9,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
