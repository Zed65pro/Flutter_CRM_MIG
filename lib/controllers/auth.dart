import 'dart:convert';
import 'package:crm/api/api_client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final RxBool _isAuthenticated = false.obs;
  final RxString _token = "".obs;
  final RxMap<dynamic, dynamic> _user = {}.obs;
  final ApiClient apiClient = Get.find();

  // Initialize SharedPreferences instance
  late SharedPreferences _prefs;

  // Loading state variable
  final RxBool _loading = true.obs;

  // Getter for loading state
  RxBool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _loading.value = true;
    _prefs = await SharedPreferences.getInstance();
    await _loadAuthData();
    print('Initialization completed');

    // await Future.delayed(const Duration(seconds: 2));
    _loading.value = false;
  }

  Future<void> _loadAuthData() async {
    isAuthenticated = _prefs.getBool('isAuthenticated') ?? false;
    token = _prefs.getString('token') ?? "";
    final String? userJson = _prefs.getString('user');
    if (userJson != null) {
      user = json.decode(userJson);
    }

    if (token.isNotEmpty) {
      apiClient.setToken(token);
    }
  }

  void _saveAuthData() {
    _prefs.setBool('isAuthenticated', isAuthenticated);
    _prefs.setString('token', token);
    _prefs.setString('user', json.encode(user));
  }

  void login(String authToken, Map<dynamic, dynamic> userObject) {
    isAuthenticated = true;
    token = authToken;
    user = userObject;
    _saveAuthData();
  }

  void logout() {
    isAuthenticated = false;
    token = "";
    user = {};
    _saveAuthData();
  }

  bool get isAuthenticated => _isAuthenticated.value;
  set isAuthenticated(bool value) => _isAuthenticated.value = value;

  String get token => _token.value;
  set token(String value) => _token.value = value;

  Map<dynamic, dynamic> get user => _user;
  set user(Map<dynamic, dynamic> value) => _user.value = value;
}
