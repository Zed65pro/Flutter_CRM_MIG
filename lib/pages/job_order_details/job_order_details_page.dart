import 'dart:io';

import 'package:crm/controllers/job_photo.dart';
import 'package:crm/models/job_order.dart';
import 'package:crm/models/job_order_image.dart';
import 'package:crm/pages/job_order_details/components/job_map.dart';
import 'package:crm/pages/job_order_details/components/job_order_card_details.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/components/appbar/home_appbar.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobOrderDetails extends StatefulWidget {
  const JobOrderDetails({super.key});

  @override
  State<JobOrderDetails> createState() => _JobOrderDetailsState();
}

class _JobOrderDetailsState extends State<JobOrderDetails> {
  final AuthController authController = Get.find();
  late RxList<JobOrderImage> images;
  late JobOrder jobOrder;
  final JobPhotoController jobPhotoController = Get.put(JobPhotoController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobOrder = ModalRoute.of(context)!.settings.arguments as JobOrder;
    images = jobOrder.images.obs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set a light background color
      // resizeToAvoidBottomInset: true,
      appBar: HomeAppBar(title: 'Customer Details'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              JobOrderCardDetails(jobOrder: jobOrder),
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
                          // Get.toNamed(RoutesUrls.updateCustomer,
                          //     arguments: customer);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Color.fromARGB(255, 186, 36, 36)),
                        onPressed: () async {
                          Get.defaultDialog(
                            title: 'Delete customer',
                            content: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Are you sure you want to delete this customer?',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            textConfirm: 'OK',
                            onConfirm: () async {
                              // Add logic to add a service to a customer
                              // bool result = await handleDeleteCustomer(
                              //     authController.token, customer.id);

                              // if (result) {
                              //   Get.offNamedUntil(
                              //       RoutesUrls.customersPage,
                              //       (route) =>
                              //           route.settings.name ==
                              //           RoutesUrls.homePage);
                              // } else {}
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
              const Center(
                child: Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: Get.height / 3,
                  width: Get.width,
                  child: JobMap(
                    jobLocation: jobOrder.location.toLatLng(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Submittal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                'Images',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Obx(() {
                      final photoPath = jobPhotoController.photoPath.value;
                      if (photoPath.isEmpty) {
                        return const Center(
                            child: Text('No photos provided..'));
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
                        Get.toNamed(RoutesUrls.jobCamera);
                      },
                      child: Text(
                        jobPhotoController.photoPath.value.isEmpty
                            ? 'Add Completion Photo'
                            : 'Add more Photo',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Feedback',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextField(
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your feedback...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey[400]!,
                        width: 1.0,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 249, 249),
                    contentPadding: const EdgeInsets.all(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void onFilterPressed() {}
}
