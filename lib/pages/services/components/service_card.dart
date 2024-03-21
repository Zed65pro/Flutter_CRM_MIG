import 'package:firstapp/models/service.dart';
import 'package:firstapp/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
  });

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
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            // Add any action you want to perform when the arrow button is pressed
            print("pressed");
            Get.toNamed(RoutesUrls.serviceDetails, arguments: service);
          },
        ),
        onTap: () {
          // Add any action you want to perform when the list tile is tapped
          print("pressed");
          Get.toNamed(RoutesUrls.serviceDetails, arguments: service);
        },
      ),
    );
  }
}
