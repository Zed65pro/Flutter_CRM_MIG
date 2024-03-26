import 'dart:convert';

import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/models/service.dart';
import 'package:firstapp/pages/services/components/services_list.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/services/components/search_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final AuthController authController = Get.find();
  final RxList<Service> services = <Service>[].obs;

  @override
  void initState() {
    super.initState();
    getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Services Page',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ServicesSearchBar(
              onSearchPressed: onSearchPressed,
              onFilterPressed: onFilterPressed,
              searchController: TextEditingController(),
            ),
            const SizedBox(height: 16.0),
            Expanded(child: Obx(() {
              if (services.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ServicesList(services: services);
              }
            })
                // child: FutureBuilder(
                // future: getServices(), // Pass the future here
                // builder: (context, snapshot) {
                //   if (snapshot.connectionState == ConnectionState.waiting) {
                //     // Show a loading indicator while waiting for data
                //     return const Center(child: CircularProgressIndicator());
                //   } else if (snapshot.hasError) {
                //     // Show an error message if there's an error
                //     return Center(child: Text('Error: ${snapshot.error}'));
                //   } else {
                //     return ServicesList(services: services);
                // If data is successfully fetched, display the ListView
                // return ListView.builder(
                //   itemCount: services.length,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       title: Text(services[index].name),
                //       subtitle: Text(services[index].description),
                //       // Add more information as needed
                //     );
                //   },
                // );
                //     }
                //   },
                // ),
                ),
          ],
        ),
      ),
    );
  }

  void onSearchPressed(String search) {
    // Simulate search functionality
    print('Search pressed with query: $search');
    getServices(search: search);
  }

  void onFilterPressed() {
    // Simulate filter functionality
    print('Filter pressed');
  }

  Future<void> getServices({String search = ''}) async {
    print("called");
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_BASE_URL']}services/?search=$search'),
        headers: {'Authorization': 'Token ${authController.token}'},
      );
      print(response);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> results = responseData['results'];
        final List<Service> serviceList =
            results.map((json) => Service.fromJson(json)).toList();
        services.assignAll(serviceList);
      } else {
        throw Exception('Failed to get services.');
      }
    } catch (e) {
      print('Error fetching services: $e');
      rethrow; // Rethrow the error to be caught by the FutureBuilder
    }
  }
}
