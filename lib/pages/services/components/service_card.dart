import 'package:crm/controllers/auth.dart';
import 'package:crm/models/service.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCard extends StatelessWidget {
  ServiceCard({
    super.key,
    required this.service,
    required this.handleDeleteServicesParent,
    this.isFromCustomer = false,
  });
  final AuthController authController = Get.find();
  final void Function(int serviceId) handleDeleteServicesParent;
  final bool isFromCustomer;

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          service.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          service.description,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isFromCustomer)
              IconButton(
                icon: const Icon(Icons.edit,
                    color: Color.fromARGB(255, 7, 78, 136)),
                onPressed: () {
                  Get.toNamed(RoutesUrls.serviceDetails, arguments: service);
                },
              ),
            IconButton(
              icon: const Icon(Icons.delete,
                  color: Color.fromARGB(255, 158, 53, 53)),
              onPressed: () {
                if (Get.isOverlaysOpen) {
                  Get.back();
                }
                Get.defaultDialog(
                    title: "Confirm Delete",
                    content: const Text(
                        "Are you sure you want to delete this service?"),
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    onConfirm: () {
                      handleDeleteServicesParent(service.id);
                      Get.back();
                    },
                    onCancel: () {
                      // if (Get.isOverlaysOpen) {
                      //   Get.back();
                      // }
                    });
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.arrow_forward),
            //   onPressed: () {
            //     // Add any action you want to perform when the arrow button is pressed
            //     Get.toNamed(RoutesUrls.serviceDetails, arguments: service);
            //   },
            // ),
          ],
        ),
        onTap: () {
          // Add any action you want to perform when the list tile is tapped
          if (!isFromCustomer) {
            Get.toNamed(RoutesUrls.serviceDetails, arguments: service);
          }
        },
      ),
    );
  }
}
