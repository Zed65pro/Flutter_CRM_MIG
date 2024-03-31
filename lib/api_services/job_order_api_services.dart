import 'dart:convert';
import 'dart:io';
import 'package:crm/components/dialogs/dialogs.dart';
import 'package:crm/models/job_order.dart';
import 'package:crm/models/point.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const int DEFAULT_TIMEOUT_SECONDS = 5;

Future<bool> createJobOrder(
    {required String name,
    required String description,
    required String area,
    required String city,
    required String street,
    required String phoneNumber,
    required String email,
    required String token,
    Point? location}) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}joborders/');
    String authToken = 'Token $token';
    Map<String, dynamic> body = {
      'name': name,
      'description': description,
      'area': area,
      'city': city,
      'street': street,
      'phone_number': phoneNumber,
      'email': email,
      if (location != null) 'location': location.toJson(),
    };
    final response = await http
        .post(
      url,
      headers: {'Authorization': authToken},
      body: jsonEncode(body),
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
      showErrorSnackbar('Failed to create job order: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to create job order. Please try again.');
  }
  return false;
}

Future<bool> updateJobOrder({
  required String jobId,
  required String name,
  required String description,
  required String area,
  required String city,
  required String street,
  required String phoneNumber,
  required String email,
  required String token,
  Point? location,
  String? status,
  String? feedback,
}) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}joborders/$jobId/');
    String authToken = 'Token $token';
    Map<String, dynamic> body = {
      'name': name,
      'description': description,
      'area': area,
      'city': city,
      'street': street,
      'phone_number': phoneNumber,
      'email': email,
    };
    if (status != null) body['status'] = status;
    if (feedback != null) body['feedback'] = feedback;
    if (location != null) body['location'] = location.toJson();

    final response = await http
        .put(
      url,
      headers: {'Authorization': authToken},
      body: jsonEncode(body),
    )
        .timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS),
            onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar('Failed to update job order: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to update job order. Please try again.');
  }
  return false;
}

Future<bool> deleteJobOrder(String token, String jobId) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}joborders/$jobId/');
    String authToken = 'Token $token';
    final response = await http.delete(
      url,
      headers: {'Authorization': authToken},
    ).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });

    if (response.statusCode == 204) {
      showSuccessSnackbar('Job order successfully deleted!');
      return true;
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar('Failed to delete job order. Please try again.');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to delete job order. Please try again.');
  }
  return false;
}

Future<bool> addJobOrderImage({
  required String jobId,
  required String imagePath,
  required String token,
}) async {
  try {
    Uri url =
        Uri.parse('${dotenv.env['API_BASE_URL']}joborders/$jobId/images/');
    String authToken = 'Token $token';

    // Read the image file
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    Map<String, dynamic> body = {
      'file': base64Image,
    };

    final response = await http
        .post(
      url,
      headers: {
        'Authorization': authToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
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
      showErrorSnackbar(
          'Failed to add image to job order: ${response.statusCode}');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showErrorSnackbar('Failed to add image to job order. Please try again.');
  }
  return false;
}

Future<dynamic> fetchJobOrdersApi(
    String token, String search, int currentPage, int pageSize) async {
  try {
    print(token);
    Uri url = Uri.parse(
        '${dotenv.env['API_BASE_URL']}joborders/?search=$search&page=$currentPage&pageSize=$pageSize/');
    String authToken = 'Token $token';
    if (search.isNotEmpty) {
      currentPage = 1;
    }
    final response = await http.get(
      url,
      headers: {'Authorization': authToken},
    ).timeout(const Duration(seconds: 3), onTimeout: () {
      return http.Response('Error', 408);
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> results = responseData['results'];
      final List<JobOrder> jobOrderList =
          results.map((json) => JobOrder.fromJson(json)).toList();

      return [jobOrderList, responseData['count'], currentPage];
    } else if (response.statusCode == 408) {
      showFailureDialog('Request timed out. Please try again later');
    } else {
      showFailureDialog('Failed to get job Orders.');
    }
  } on SocketException {
    showFailureDialog('No internet connection or server is unreachable');
  } catch (e) {
    print('Error fetching job orders: $e');
    rethrow; // Rethrow the error to be caught by the FutureBuilder
  }
}
