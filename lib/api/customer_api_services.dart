// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:crm/components/dialogs/dialogs.dart';
import 'package:crm/models/customer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const int DEFAULT_TIMEOUT_SECONDS = 5;

Future<bool> handleCreateCustomer({
  required String firstName,
  required String lastName,
  required String address,
  required String phoneNumber,
  required String token,
}) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}customers/');
    String authToken = 'Token $token';
    Object body = {
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'phone_number': phoneNumber,
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
      showErrorSnackbar('Failed to create customer: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to create customer. Please try again.');
  }
  return false;
}

Future<dynamic> handleUpdateCustomer(
    {required String firstName,
    required String lastName,
    required String address,
    required String phoneNumber,
    required String token,
    required int customerId}) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}customers/$customerId/');
    String authToken = 'Token $token';
    Object body = {
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'phone_number': phoneNumber,
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
      showErrorSnackbar('Failed to update customer: ${response.statusCode}');
    }
  } on SocketException {
    // Handle SocketException: No internet connection or server not reachable
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to create customer. Please try again.');
  }
  return false;
}

Future<bool> handleDeleteCustomer(String token, int customerId) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}customers/$customerId/');
    String authToken = 'Token $token';
    final response = await http.delete(
      url,
      headers: {'Authorization': authToken},
    ).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });

    print(response.statusCode);
    if (response.statusCode == 204) {
      showSuccessSnackbar('Customer successfully deleted!');
      return true;
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar('Failed to delete customer. Please try again.');
    }
  } on SocketException {
    // Handle SocketException: No internet connection or server not reachable
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to delete customer. Please try again.');
  }
  return false;
}

Future<bool> deleteServiceFromCustomer(
    String token, int customerId, int serviceId) async {
  try {
    Uri url = Uri.parse(
        '${dotenv.env['API_BASE_URL']}customers/$customerId/remove-service/$serviceId/');
    String authToken = 'Token $token';
    final response = await http.patch(
      url,
      headers: {'Authorization': authToken},
    ).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 200) {
      showSuccessSnackbar('Customer Service successfuly deleted!');
      return true;
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar(
          'Failed to remove service from customer: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar(
        'Failed to remove service from customer. Please try again.');
  }
  return false;
}

Future<bool> addServiceToCustomer(
    String token, int customerId, int serviceId) async {
  try {
    Uri url = Uri.parse(
        '${dotenv.env['API_BASE_URL']}customers/$customerId/add-service/$serviceId/');
    String authToken = 'Token $token';
    final response = await http.put(
      url,
      headers: {'Authorization': authToken},
    ).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 200) {
      showSuccessSnackbar('Service successfuly added to customer!');
      return true;
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar(
          'Failed to add service to customer: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to add service to customer. Please try again.');
  }
  return false;
}

Future<Customer?> getCustomerById(String token, int customerId) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}customers/$customerId/');
    String authToken = 'Token $token';
    final response = await http
        .get(url, headers: {'Authorization': authToken}).timeout(
            const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });

    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar('Failed to retrieve customer: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to get customer. Please try again.');
  }
  return null;
}
