import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaled_list/scaled_list.dart';

import '../../../models/service.dart';

class ServicesList extends StatelessWidget {
  final List<Service> services;

  const ServicesList({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ScaledList(
        itemCount: services.length,
        itemColor: (index) {
          return Colors.grey;
        },
        itemBuilder: (index, selectedIndex) {
          final service = services[index];
          return GestureDetector(
            onTap: () =>
                {Get.toNamed(RoutesUrls.serviceDetails, arguments: service)},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: Text(
                    service.name,
                    style: TextStyle(
                      fontSize: selectedIndex == index ? 25 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.description,
                        style: TextStyle(
                          fontSize: selectedIndex == index ? 20 : 16,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Price: ${service.price}',
                        style: TextStyle(
                          fontSize: selectedIndex == index ? 18 : 14,
                        ),
                      ),
                      Text(
                        'Duration: ${service.durationMonths} months',
                        style: TextStyle(
                          fontSize: selectedIndex == index ? 18 : 14,
                        ),
                      ),
                      Text(
                        'Created by: ${service.createdBy.username}',
                        style: TextStyle(
                          fontSize: selectedIndex == index ? 18 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
