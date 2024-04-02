import 'dart:convert';
import 'package:crm/api/api_routes.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/models/customer.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crm/components/dialogs/dialogs.dart';
import 'package:crm/models/job_order.dart';
import 'package:crm/models/point.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

class ApiClient extends GetxService {
  late Dio _dio;
  late String _baseUrl;
  late String _token;
  late Duration timeoutSeconds;

  ApiClient() {
    _dio = Dio();
    _baseUrl = dotenv.env['API_BASE_URL']!;
    _token = '';
    timeoutSeconds = const Duration(seconds: 5);

    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = timeoutSeconds * 1000;
    _dio.options.receiveTimeout = timeoutSeconds * 1000;
  }

  void setToken(String token) {
    _token = token;
    _dio.options.headers['Authorization'] = 'Token $token';
  }

  Future<bool> createJobOrder({
    required String name,
    required String description,
    required String area,
    required String city,
    required String street,
    required String phoneNumber,
    required String email,
    Point? location,
  }) async {
    try {
      final Response response = await _dio.post(
        ApiRoutes.createJobOrder,
        data: {
          'name': name,
          'description': description,
          'area': area,
          'city': city,
          'street': street,
          'phone_number': phoneNumber,
          'email': email,
          if (location != null) 'location': location.toJson(),
        },
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return false;
  }

  Future<dynamic> updateJobOrder({
    required int jobId,
    required Map<String, dynamic> updatedJobOrderJson,
  }) async {
    try {
      final Response response = await _dio.put(
        ApiRoutes.updateJobOrder(jobId),
        data: updatedJobOrderJson,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update job order: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return null;
  }

  Future<dynamic> addJobOrderImage({
    required int jobId,
    required String imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagePath),
      });
      final response = await _dio.post(
        ApiRoutes.addJobOrderImage(jobId),
        data: formData,
      );
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(
            'Failed to add image to job order: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return null;
  }

  Future<dynamic> addJobOrderComment({
    required int jobId,
    required String body,
  }) async {
    try {
      final Response response = await _dio.post(
        ApiRoutes.addJobOrderComment(jobId),
        data: {'body': body},
      );
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(
            'Failed to comment on job order: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return null;
  }

  Future<dynamic> fetchJobOrders({
    required String search,
    required int currentPage,
    required List<dynamic> filterList,
  }) async {
    try {
      String filterJson = json.encode(filterList);

      print('$_baseUrl${ApiRoutes.getJobOrders}');
      final response = await _dio.get(
        ApiRoutes.getJobOrders,
        queryParameters: {
          'search': search,
          'filters': filterJson,
          'page': currentPage.toString(),
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> results = responseData['results'];
        final List<JobOrder> jobOrderList =
            results.map((json) => JobOrder.fromJson(json)).toList();
        return [jobOrderList, responseData['count'], currentPage];
      } else {
        throw Exception('Failed to fetch job orders: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return null;
  }

  Future<bool> handleCreateCustomer({
    required String firstName,
    required String lastName,
    required String address,
    required String phoneNumber,
    required String token,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'first_name': firstName,
        'last_name': lastName,
        'address': address,
        'phone_number': phoneNumber,
      };
      final response = await _dio.post(
        ApiRoutes.createCustomer,
        data: body,
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create customer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return false;
  }

  Future<dynamic> handleUpdateCustomer({
    required String firstName,
    required String lastName,
    required String address,
    required String phoneNumber,
    required String token,
    required int customerId,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'first_name': firstName,
        'last_name': lastName,
        'address': address,
        'phone_number': phoneNumber,
      };
      final response = await _dio.put(
        ApiRoutes.updateCustomer(customerId),
        data: body,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data);
      } else {
        throw Exception('Failed to update customer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return false;
  }

  Future<bool> handleDeleteCustomer(String token, int customerId) async {
    try {
      final response =
          await _dio.delete(ApiRoutes.deleteCustomerById(customerId));
      if (response.statusCode == 204) {
        showSuccessSnackbar('Customer Service successfully deleted!');
        return true;
      } else {
        throw Exception('Failed to delete customer. Please try again.');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return false;
  }

  Future<bool> deleteServiceFromCustomer(
      String token, int customerId, int serviceId) async {
    try {
      final response = await _dio.patch(
        ApiRoutes.removeServiceFromCustomer(customerId, serviceId),
      );
      if (response.statusCode == 200) {
        showSuccessSnackbar('Customer Service successfully deleted!');
        return true;
      } else {
        throw Exception(
            'Failed to remove service from customer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return false;
  }

  Future<bool> addServiceToCustomer(
      String token, int customerId, int serviceId) async {
    try {
      final response = await _dio.put(
        ApiRoutes.addServiceToCustomer(customerId, serviceId),
      );
      if (response.statusCode == 200) {
        showSuccessSnackbar('Service successfully added to customer!');
        return true;
      } else {
        throw Exception(
            'Failed to add service to customer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return false;
  }

  Future<Customer?> getCustomerById(String token, int customerId) async {
    try {
      final response = await _dio.get(
        ApiRoutes.getCustomerById(customerId),
      );
      if (response.statusCode == 200) {
        return Customer.fromJson(json.decode(response.data));
      } else {
        throw Exception('Failed to retrieve customer: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return null;
  }

  Future<bool> handleCreateService({
    required String name,
    required String description,
    required String price,
    required String durationMonths,
  }) async {
    try {
      final response = await _dio.post(
        ApiRoutes.createService,
        data: {
          'name': name,
          'description': description,
          'price': price,
          'duration_months': durationMonths,
        },
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return false;
  }

  Future<dynamic> handleUpdateService({
    required String name,
    required String description,
    required String price,
    required String durationMonths,
    required int serviceId,
  }) async {
    try {
      final response = await _dio.put(
        ApiRoutes.updateService(serviceId),
        data: {
          'name': name,
          'description': description,
          'price': price,
          'duration_months': durationMonths,
        },
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update service: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return false;
  }

  Future<bool> handleDeleteService(int serviceId) async {
    try {
      final response =
          await _dio.delete(ApiRoutes.deleteServiceById(serviceId));
      if (response.statusCode == 204) {
        showSuccessSnackbar('Service successfully deleted!');
        return true;
      } else {
        throw Exception('Failed to delete service: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print(e);
      showErrorSnackbar('Error: ${e}');
    }
    return false;
  }

  void handleLogout(AuthController authController) async {
    try {
      final response = await _dio.post(ApiRoutes.logout);
      if (response.statusCode == 204) {
        authController.logout();
        Get.offAllNamed(RoutesUrls.loginPage);
        showSuccessSnackbar('Successfully logged out');
      } else {
        throw Exception('Failed to logout: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print("Failed to logout! $e");
      showFailureDialog('Failed to logout');
    }
  }

  void handleLogin(
    AuthController authController,
    String? username,
    String? password,
  ) async {
    try {
      final response = await _dio.post(ApiRoutes.login, data: {
        'username': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        final responseBody = response.data;
        getUserFromToken(responseBody['auth_token'], authController);
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print("Error occurred: $e");
      showFailureDialog('Invalid username or password. Please try again.');
    }
  }

  void getUserFromToken(String token, AuthController authController) async {
    try {
      final response = await _dio.get(ApiRoutes.userMe);
      if (response.statusCode == 200) {
        final responseBody = response.data;
        print(responseBody);
        authController.login(token, responseBody);
        Get.offAllNamed(RoutesUrls.homePage);
        showSuccessSnackbar('You have logged in successfully to your account.');
      } else {
        throw Exception('Failed to get user: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print(e);
      _handleError(e);
    } catch (e) {
      print('error getting user $e');
      showFailureDialog('Invalid username or password. Please try again.');
    }
  }

  void _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else if (error.type == DioExceptionType.connectionError) {
      showErrorSnackbar('No internet connection. Please try again.');
    } else if (error.type == DioExceptionType.badResponse) {
      showErrorSnackbar('Error: ${error.response?.statusCode}');
    } else if (error.type == DioExceptionType.unknown) {
      showErrorSnackbar('Error: ${error.message}');
    }
  }
}
