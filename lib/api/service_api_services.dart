// ignore_for_file: constant_identifier_names, avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:crm/components/dialogs/dialogs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const int DEFAULT_TIMEOUT_SECONDS = 5;

Future<bool> handleCreateService({
  required String name,
  required String description,
  required String price,
  required String durationMonths,
  required String token,
}) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}services/');
    String authToken = 'Token $token';
    Object body = {
      'name': name,
      'description': description,
      'price': price,
      'duration_months': durationMonths,
    };
    final response = await http
        .post(
      url,
      headers: {'Authorization': authToken},
      body: body,
    )
        .timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS),
            onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar('Failed to create service: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to create service. Please try again.');
  }
  return false;
}

Future<dynamic> handleUpdateService(
    {required String name,
    required String description,
    required String price,
    required String durationMonths,
    required String token,
    required int serviceId}) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}services/$serviceId/');
    String authToken = 'Token $token';
    Object body = {
      'name': name,
      'description': description,
      'price': price,
      'duration_months': durationMonths,
    };
    final response = await http
        .put(
      url,
      headers: {'Authorization': authToken},
      body: body,
    )
        .timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS),
            onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar('Failed to edit service: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to create service. Please try again.');
  }
  return false;
}

Future<bool> handleDeleteService(String token, int serviceId) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}services/$serviceId/');
    String authToken = 'Token $token';
    final response = await http.delete(
      url,
      headers: {'Authorization': authToken},
    ).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });

    print(response.statusCode);
    if (response.statusCode == 204) {
      showSuccessSnackbar('Service successfully deleted!');
      return true;
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar('Failed to delete service. Please try again.');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to delete service. Please try again.');
  }
  return false;
}
