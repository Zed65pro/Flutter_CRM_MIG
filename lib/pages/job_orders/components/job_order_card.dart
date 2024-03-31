import 'package:crm/models/job_order.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobOrderCard extends StatelessWidget {
  final JobOrder jobOrder;

  const JobOrderCard({super.key, required this.jobOrder});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          jobOrder.name.length < 10
              ? jobOrder.name
              : '${jobOrder.name.substring(0, 10)}...',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Phone number: ${jobOrder.phoneNumber}',
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                        "Are you sure you want to delete this job order?"),
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    onConfirm: () {
                      Get.back();
                    });
              },
            ),
          ],
        ),
        onTap: () {
          Get.toNamed(RoutesUrls.jobOrderDetails, arguments: jobOrder);
        },
      ),
    );
  }
}
