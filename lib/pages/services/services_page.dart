import 'dart:convert';

import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/models/service.dart';
import 'package:firstapp/pages/services/components/service_card.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/services/components/search_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final AuthController authController = Get.find();
  final RxList<Service> services = <Service>[].obs;
  int currentPage = 1;
  int pageSize = 6; // Number of items per page
  bool isLoading = false;

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
            Expanded(
              child: Obx(() {
                if (services.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return ServiceCard(service: service);
                    },
                  );
                }
              }),
            ),
            _buildPaginationControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    int totalPages = (services.length / pageSize).ceil();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: currentPage > 1 ? () => changePage(-1) : null,
            child: const Text('<'),
          ),
          const SizedBox(width: 16.0),
          for (int i = 1; i <= totalPages; i++)
            ElevatedButton(
              onPressed: () => goToPage(i),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return null; // Use the default button color when disabled
                    }
                    return i == currentPage ? Colors.blue : null;
                  },
                ),
              ),
              child: Text(i.toString()),
            ),
          const SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: services.length < pageSize ? null : () => changePage(1),
            child:
                isLoading ? const CircularProgressIndicator() : const Text('>'),
          )
        ],
      ),
    );
  }

  void goToPage(int page) {
    setState(() {
      currentPage = page;
      getServices();
    });
  }

  void changePage(int pageChange) {
    setState(() {
      currentPage += pageChange;
      getServices();
    });
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
    setState(() {
      isLoading = true;
    });

    print("called");
    try {
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['API_BASE_URL']}services/?search=$search&page=$currentPage&pageSize=$pageSize'),
        headers: {'Authorization': 'Token ${authController.token}'},
      );
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
      throw e; // Rethrow the error to be caught by the FutureBuilder
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
