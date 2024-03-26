// import 'package:firstapp/controllers/auth.dart';
// import 'package:firstapp/pages/home_page/home_page.dart';
// import 'package:firstapp/pages/login_page/components/login_form.dart';
// import 'package:firstapp/settings/routes_urls.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginPage extends StatelessWidget {
//   final AuthController authController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     print(
//         "Login Screen: Authenticated Status ${authController.isAuthenticated}");

//     return Scaffold(
//       body: Obx(() {
//         if (authController.loading) { // In order for this to work again return bool from auth controller instead of RxBool
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           if (authController.isAuthenticated) {
//             // Navigate to home page only if authenticated
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               Get.offAllNamed(RoutesUrls.homePage);
//             });
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             return Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color.fromARGB(255, 41, 121, 201),
//                     Color.fromARGB(198, 195, 58, 219),
//                   ],
//                 ),
//               ),
//               child: LoginForm(authController: authController),
//             );
//           }
//         }
//       }),
//     );
//   }
// }
