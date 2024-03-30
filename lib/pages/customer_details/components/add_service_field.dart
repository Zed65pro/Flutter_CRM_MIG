import 'package:crm/controllers/auth.dart';
import 'package:crm/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

import '../../../models/service.dart';

class AddServiceToCustomer extends StatelessWidget {
  const AddServiceToCustomer({
    super.key,
    required this.services,
    required this.customer,
    required this.authController,
    required this.filteredServices,
    required this.handleAddService,
  });

  final RxList<Service> services;
  final Customer customer;
  final AuthController authController;
  final RxList<Service> filteredServices;
  final void Function(Service serviceId) handleAddService;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      children: [
        const Center(
          child: Text('Add a service',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (services.isNotEmpty) {
            return SearchField<Service>(
              autoCorrect: true,
              autofocus: false,
              hint: 'Select a service to add',
              // searchStyle: TextStyle(
              //   fontSize: 18,
              //   color: Colors.black.withOpacity(0.8),
              // ),
              // searchInputDecoration: InputDecoration(
              //   focusedBorder: OutlineInputBorder(
              //     borderSide: BorderSide(
              //       color: Colors.black.withOpacity(0.8),
              //     ),
              //   ),
              //   border: const OutlineInputBorder(
              //     borderSide: BorderSide(color: Colors.red),
              //   ),
              // ),
              maxSuggestionsInViewPort: 100,
              suggestionAction: SuggestionAction.unfocus,
              suggestionState: Suggestion.expand,
              suggestionDirection: SuggestionDirection.up,
              marginColor: Colors.purple,
              onSuggestionTap: (SearchFieldListItem<Service> field) {
                if (field.item != null) {
                  Service selectedService = field.item!;
                  bool isServiceSelected = customer.services
                      .any((service) => service.id == selectedService.id);
                  if (isServiceSelected) {
                    Get.snackbar(
                      'Error',
                      'Service already exists with user.',
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  } else {
                    Get.defaultDialog(
                      title: 'Add Service',
                      content: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Are you sure you want to add this service?',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      textConfirm: 'OK',
                      onConfirm: () async {
                        // Add logic to add a service to a customer
                        Get.back();
                        handleAddService(selectedService);
                      },
                      textCancel: 'Cancel', // Add a cancel button
                      onCancel: () {
                        // Get.back(); // Close the dialog without adding the service
                      },
                    );
                  }
                }
              },
              suggestions: services
                  .map(
                    (e) => SearchFieldListItem<Service>(
                      e.name,
                      item: e,
                      // Custom suggestion design
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              e.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(
              child: Text(
                'No services found.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }
        }),
        const SizedBox(height: 26),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }
}
