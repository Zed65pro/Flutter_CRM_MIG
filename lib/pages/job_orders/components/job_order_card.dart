import 'package:crm/controllers/job_order.dart';
import 'package:crm/models/job_order.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobOrderCard extends StatelessWidget {
  final JobOrder jobOrder;
  final JobOrderController jobOrderController = Get.find();
  JobOrderCard({super.key, required this.jobOrder});

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
        onTap: () {
          jobOrderController.selectedJobOrder.value = jobOrder;
          Get.toNamed(RoutesUrls.jobOrderDetails);
        },
      ),
    );
  }
}
