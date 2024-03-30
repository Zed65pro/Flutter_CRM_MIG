import 'dart:convert';
import 'package:firstapp/api_services/customer_api_services.dart';
import 'package:firstapp/pages/customer_details/components/add_service_field.dart';
import 'package:firstapp/pages/customer_details/components/customer_details_card.dart';
import 'package:firstapp/pages/services/components/service_card.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:http/http.dart' as http;
import 'package:firstapp/controllers/auth.dart';
import 'package:firstapp/models/service.dart';
import 'package:firstapp/pages/customers/components/search_bar.dart';
import 'package:firstapp/pages/home_page/components/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/models/customer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({super.key});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  TextEditingController query = TextEditingController();
  final AuthController authController = Get.find();
  final RxList<Service> services = <Service>[].obs;
  late RxList<Service> filteredServices;
  late Customer customer;

  @override
  void initState() {
    super.initState();
    getServices();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    customer = ModalRoute.of(context)!.settings.arguments as Customer;
    filteredServices = customer.services.obs;
  }

  @override
  Widget build(BuildContext context) {
    void onSearchPressed(String query) {
      // Create a new list to store filtered services
      List<Service> filteredList = [];

      // Iterate over each service in customer.services
      for (Service service in customer.services) {
        // Check if the name or description contains the query
        if (service.name.toLowerCase().contains(query.toLowerCase()) ||
            service.description.toLowerCase().contains(query.toLowerCase())) {
          // Add the service to the filteredList if it matches the query
          filteredList.add(service);
        }
      }

      // Assign the filteredList to filteredServices
      filteredServices.assignAll(filteredList);
    }

    return Scaffold(
      // Set a light background color
      // resizeToAvoidBottomInset: true,
      appBar: HomeAppBar(title: 'Customer Details'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     // Add your button onPressed logic here
              //     Get.offNamedUntil(RoutesUrls.customersPage,
              //         (route) => route.settings.name == RoutesUrls.homePage);
              //   },
              //   child: const Text('Press Me'),
              // ),
              CustomerCardDetails(customer: customer),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Modifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Color.fromARGB(255, 54, 143, 215)),
                        onPressed: () {
                          // Add your edit logic here
                          Get.toNamed(RoutesUrls.updateCustomer,
                              arguments: customer);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Color.fromARGB(255, 186, 36, 36)),
                        onPressed: () async {
                          Get.defaultDialog(
                            title: 'Delete customer',
                            content: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Are you sure you want to delete this customer?',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            textConfirm: 'OK',
                            onConfirm: () async {
                              // Add logic to add a service to a customer
                              bool result = await handleDeleteCustomer(
                                  authController.token, customer.id);

                              if (result) {
                                Get.offNamedUntil(
                                    RoutesUrls.customersPage,
                                    (route) =>
                                        route.settings.name ==
                                        RoutesUrls.homePage);
                              } else {}
                            },
                            textCancel: 'Cancel', // Add a cancel button
                            onCancel: () {
                              // Get.back(); // Close the dialog without adding the service
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              AddServiceToCustomer(
                services: services,
                customer: customer,
                authController: authController,
                filteredServices: filteredServices,
                handleAddService: handleAddService,
              ),
              Obx(() {
                if (filteredServices.isNotEmpty) {
                  return customerServicesDisplay(onSearchPressed);
                } else {
                  return const Center(
                    child: Text(
                      'No subscribed services found.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  ListView customerServicesDisplay(
      void Function(String query) onSearchPressed) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Center(
          child: Text('Subscribed services',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        ServicesSearchBar(
          onSearchPressed: onSearchPressed,
          onFilterPressed: onFilterPressed,
          searchController: query,
        ),
        const SizedBox(height: 16),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredServices.length,
            itemBuilder: (context, index) {
              final service = filteredServices[index];
              return ServiceCard(
                service: service,
                isFromCustomer: true,
                handleDeleteServicesParent: handleDeleteServicesParent,
              );
            }),
      ],
    );
  }

  void onFilterPressed() {}
  Future<void> getServices({String search = ''}) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_BASE_URL']}services/all/'),
        headers: {'Authorization': 'Token ${authController.token}'},
      ).timeout(const Duration(seconds: 3), onTimeout: () {
        return http.Response('Error', 408);
      });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> results = responseData;

        final List<Service> serviceList =
            results.map((json) => Service.fromJson(json)).toList();
        services.assignAll(serviceList);
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
    } catch (e) {
      print('Error fetching services: $e');
      rethrow; // Rethrow the error to be caught by the FutureBuilder
    }
  }

  void handleDeleteServicesParent(int serviceId) async {
    bool res = await deleteServiceFromCustomer(
        authController.token, customer.id, serviceId);

    if (res) {
      customer.services.removeWhere((element) => element.id == serviceId);
      filteredServices.removeWhere((element) => serviceId == element.id);
    }
  }

  void handleAddService(Service selectedService) async {
    final res = await addServiceToCustomer(
        authController.token, customer.id, selectedService.id);
    if (res) {
      customer.services.add(selectedService);
      filteredServices.add(selectedService);
    }
  }
}
