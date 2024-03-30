import 'package:crm/controllers/auth.dart';
import 'package:crm/pages/login_page/components/login_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    print(
        "Login Screen: Authenticated Status ${authController.isAuthenticated}");

    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 41, 121, 201),
            Color.fromARGB(198, 195, 58, 219),
          ],
        ),
      ),
      child: LoginForm(authController: authController),
    ));
  }
}
