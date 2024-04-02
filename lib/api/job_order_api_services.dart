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

Future<dynamic> updateJobOrder({
  required int jobId,
  String? token,
  required Map<String, dynamic> updatedJobOrderJson,
}) async {
  try {
    if (token == null) {
      throw Exception('Token is required for authorization.');
    }

    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}joborders/$jobId/');
    String authToken = 'Token $token';

    final response = await http
        .put(
          url,
          headers: {
            'Authorization': authToken,
            'Content-Type': 'application/json',
          },
          body: updatedJobOrderJson,
        )
        .timeout(
          const Duration(seconds: DEFAULT_TIMEOUT_SECONDS),
          onTimeout: () => http.Response('Error', 408),
        );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 408) {
      throw Exception('Request timed out. Please try again.');
    } else {
      throw Exception('Failed to update job order: ${response.statusCode}');
    }
  } on SocketException {
    throw Exception('No internet connection or server not reachable.');
  } catch (e) {
    print("Error occurred: $e");
    showFailureDialog('$e');
    // throw Exception('Failed to update job order. Please try again.');
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

Future<dynamic> addJobOrderImage({
  required int jobId,
  required String imagePath,
  required String token,
}) async {
  try {
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}joborders/image/$jobId/');
    String authToken = 'Token $token';

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = authToken;
    // Attach the image file
    var file = await http.MultipartFile.fromPath('file', imagePath);
    request.files.add(file);
    // Send the request
    var streamedResponse = await request.send();
    // Handle the response
    var response = await http.Response.fromStream(streamedResponse);

    // print(json.decode(response.body));
    if (response.statusCode == 201) {
      return json.decode(response.body);
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

Future<dynamic> addJobOrderComment({
  required int jobId,
  required String body,
  required String token,
}) async {
  try {
    Uri url =
        Uri.parse('${dotenv.env['API_BASE_URL']}joborders/comment/$jobId/');
    String authToken = 'Token $token';
    print(body);
    final response = await http.post(
      url,
      headers: {
        'Authorization': authToken,
      },
      body: {'body': body},
    ).timeout(const Duration(seconds: DEFAULT_TIMEOUT_SECONDS), onTimeout: () {
      return http.Response('Error', 408);
    });

    print(json.decode(response.body));
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 408) {
      showErrorSnackbar('Request timed out. Please try again.');
    } else {
      showErrorSnackbar(
          'Failed to Comment to job order: ${response.statusCode}');
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
    {required String token,
    required String search,
    required int currentPage,
    required List<dynamic> filterList}) async {
  try {
    String filterJson = json.encode(filterList);
    Uri url = Uri.parse('${dotenv.env['API_BASE_URL']}joborders/');
    String authToken = 'Token $token';
    if (search.isNotEmpty) {
      currentPage = 1;
    }
    url = url.replace(queryParameters: {
      'search': search,
      'filters': filterJson,
      'page': currentPage.toString(),
    });
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
  }
}
