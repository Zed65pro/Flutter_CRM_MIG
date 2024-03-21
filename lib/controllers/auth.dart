// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class AuthController extends GetxController {
  final RxBool _isAuthenticated = false.obs;
  final RxString _token = "".obs;
  final RxMap<dynamic, dynamic> _user = {}.obs;

  void login(String authToken, Map<dynamic, dynamic> userObject) {
    isAuthenticated = true;
    token = authToken;
    user = userObject;
  }

  void logout() {
    isAuthenticated = false;
    token = "";
    user = {};
  }

  bool get isAuthenticated => _isAuthenticated.value;
  set isAuthenticated(bool value) => _isAuthenticated.value = value;

  String get token => _token.value;
  set token(String value) => _token.value = value;

  Map<dynamic, dynamic> get user => _user;
  set user(Map<dynamic, dynamic> value) => _user.value = value;
}
