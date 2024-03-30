import 'package:crm/api_services/service_api_services.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/models/service.dart';
import 'package:crm/pages/home_page/components/home_appbar.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/service_card_details.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final AuthController authController = Get.find();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Service service =
        ModalRoute.of(context)!.settings.arguments as Service;
    return Scaffold(
      appBar: HomeAppBar(title: 'Service Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ServiceCardDetails(service: service),
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
                        Get.toNamed(RoutesUrls.updateService,
                            arguments: service);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Color.fromARGB(255, 186, 36, 36)),
                      onPressed: () async {
                        Get.defaultDialog(
                          title: 'Delete Service from customer',
                          content: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Are you sure you want to remove this service from the customer?',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          textConfirm: 'OK',
                          onConfirm: () async {
                            // Add logic to add a service to a customer
                            bool result = await handleDeleteService(
                                authController.token, service.id);

                            if (result) {
                              Get.offNamedUntil(
                                  RoutesUrls.servicesPage,
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
          ],
        ),
      ),
    );
  }
}
