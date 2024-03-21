import 'package:firstapp/models/service.dart';
import 'package:flutter/material.dart';

class ServiceDetails extends StatelessWidget {
  const ServiceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Service service =
        ModalRoute.of(context)!.settings.arguments as Service;

    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Price:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${service.price}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Duration:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${service.durationMonths} minutes',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
