import 'package:firstapp/models/customer.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final void Function(int customerId) handleDeleteCustomerParent;

  const CustomerCard(
      {super.key,
      required this.customer,
      required this.handleDeleteCustomerParent});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          '${customer.firstName} ${customer.lastName}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Phone number: ${customer.phoneNumber}',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit,
                  color: Color.fromARGB(255, 7, 78, 136)),
              onPressed: () {
                // Add any action you want to perform when the arrow button is pressed
                Get.toNamed(RoutesUrls.customerDetails, arguments: customer);
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
                        "Are you sure you want to delete this customer?"),
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    onConfirm: () {
                      handleDeleteCustomerParent(customer.id);
                      Get.back();
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
          Get.toNamed(RoutesUrls.customerDetails, arguments: customer);
        },
      ),
    );
  }
}
