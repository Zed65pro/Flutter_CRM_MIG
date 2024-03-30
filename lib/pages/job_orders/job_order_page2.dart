import 'dart:io';

import 'package:crm/controllers/job_photo.dart';
import 'package:crm/pages/home_page/components/home_appbar.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobOrder extends StatelessWidget {
  final JobPhotoController jobPhotoController = Get.put(JobPhotoController());

  JobOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(title: 'Job Order'),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Obx(() {
              final photoPath = jobPhotoController.photoPath.value;
              if (photoPath.isEmpty) {
                return Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey, // Display empty photo placeholder
                );
              } else {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(photoPath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (jobPhotoController.photoPath.value.isEmpty) {
                  Get.toNamed(RoutesUrls.jobCamera);
                } else {
                  // Navigate to a page to update completion photo
                }
              },
              child: Text(
                jobPhotoController.photoPath.value.isEmpty
                    ? 'Add Completion Photo'
                    : 'Update Completion Photo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
