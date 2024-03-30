import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:latlong2/latlong.dart';

class JobOrderController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final feedbackController = TextEditingController();
  final statusController = TextEditingController();

  final _image = Rxn<File>();
  LatLng? selectedLocation;

  File? get image => _image.value;

  final String baseUrl = '${dotenv.env['API_BASE_URL']}';

  Future<void> selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image.value = File(pickedFile.path);
    }
  }

  Future<void> createOrder({LatLng? location}) async {
    await _uploadJobOrder(location);
  }

  Future<void> updateOrder(File? file) async {
    await _uploadJobOrder(null, file);
  }

  Future<void> _uploadJobOrder(LatLng? location, [File? file]) async {
    final uri = Uri.parse('$baseUrl/job_orders/');
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = nameController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['area'] = areaController.text;
    request.fields['city'] = cityController.text;
    request.fields['street'] = streetController.text;
    request.fields['phone_number'] = phoneNumberController.text;
    request.fields['email'] = emailController.text;

    if (location != null) {
      final locationJson = {
        'latitude': location.latitude,
        'longitude': location.longitude,
      };
      request.fields['location'] = json.encode(locationJson);
    }

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('image', 'png'),
      ));
    }

    try {
      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 201) {
        print('JobOrder created/updated successfully');
        // Handle success
      } else {
        print('Failed to create/update JobOrder');
        print('Error: ${response.body}');
        // Handle error
      }
    } catch (e) {
      print('Error uploading image: $e');
      // Handle error
    }
  }

  void setLocation(LatLng location) {
    selectedLocation = location;
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    areaController.dispose();
    cityController.dispose();
    streetController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
