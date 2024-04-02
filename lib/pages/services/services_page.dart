import 'dart:convert';
import 'dart:io';

import 'package:crm/api/service_api_services.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/models/service.dart';
import 'package:crm/components/appbar/home_appbar.dart';
import 'package:crm/pages/services/components/service_card.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:crm/pages/services/components/search_bar.dart';
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
  final RxBool emptyQuery = false.obs;
  int currentPage = 1;
  int count = 0;
  int pageSize = 6; // Number of items per page
  bool isLoading = false;
  TextEditingController query = TextEditingController();

  @override
  void initState() {
    super.initState();
    getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Services')),
      appBar: HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: getServices,
        child: ListView(
          children: [
            Container(
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
                    searchController: query,
                  ),
                  const SizedBox(height: 16.0),
                  Obx(() {
                    if (services.isEmpty && !emptyQuery.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (emptyQuery.value) {
                      return const Center(child: Text('No results found.'));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return ServiceCard(
                              service: service,
                              handleDeleteServicesParent:
                                  handleDeleteServicesParent);
                        },
                      );
                    }
                  }),
                  _buildPaginationControls(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleDeleteServicesParent(int serviceId) async {
    bool result = await handleDeleteService(authController.token, serviceId);

    if (result) {
      services.removeWhere((service) => service.id == serviceId);
    }
  }

  Widget _buildPaginationControls() {
    int totalPages = (count / pageSize).ceil();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentPage > 1 ? () => goToPage(1) : null,
              child: const Text('<<'),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: currentPage > 1 ? () => changePage(-1) : null,
              child: const Text('<'),
            ),
            const SizedBox(width: 8.0),
            Text('Page $currentPage of $totalPages'),
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: currentPage < totalPages ? () => changePage(1) : null,
              child: const Text('>'),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed:
                  currentPage < totalPages ? () => goToPage(totalPages) : null,
              child: const Text('>>'),
            ),
          ],
        ),
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

    try {
      if (search.isNotEmpty) {
        currentPage = 1;
      }
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['API_BASE_URL']}services/?search=$search&page=$currentPage&pageSize=$pageSize'),
        headers: {'Authorization': 'Token ${authController.token}'},
      ).timeout(const Duration(seconds: 3), onTimeout: () {
        return http.Response('Error', 408);
      });
      if (response.statusCode == 200) {
        if (search.isNotEmpty) {
          setState(() {
            currentPage = 1;
          });
        }
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> results = responseData['results'];
        setState(() {
          count = responseData['count'];
        });
        if (results.isNotEmpty) {
          emptyQuery.value = false;
          final List<Service> serviceList =
              results.map((json) => Service.fromJson(json)).toList();
          services.assignAll(serviceList);
        } else {
          emptyQuery.value = true;
          services.clear();
        }
      } else if (response.statusCode == 408) {
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: const Text('Request timed out. Please try again later'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: const Text('Go Back'),
              ),
              TextButton(
                onPressed: () {
                  getServices();
                  Get.back();
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to get services.');
      }
    } on SocketException {
      // Handle SocketException: No internet connection or server not reachable
      Get.defaultDialog(
        title: 'Error',
        content: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'No internet connection or server is unreachable',
            textAlign: TextAlign.center,
          ),
        ),
        textConfirm: 'OK',
        onConfirm: () {
          Get.offAllNamed(RoutesUrls.homePage);
        }, // Close the dialog
      );
    } catch (e) {
      print('Error fetching services: $e');
      rethrow; // Rethrow the error to be caught by the FutureBuilder
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
