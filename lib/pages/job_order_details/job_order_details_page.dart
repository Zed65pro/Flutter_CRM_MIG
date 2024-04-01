import 'package:crm/controllers/job_order.dart';
import 'package:crm/controllers/job_photo.dart';
import 'package:crm/models/job_order.dart';
import 'package:crm/models/job_order_image.dart';
import 'package:crm/pages/job_order_details/components/job_map.dart';
import 'package:crm/pages/job_order_details/components/job_order_card_details.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/components/appbar/home_appbar.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

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
  final JobOrderController jobOrderController = Get.find();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobOrder = jobOrderController.selectedJobOrder.value!;
    images = jobOrder.images.obs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                        onPressed: () {},
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
              const SizedBox(height: 20),
              Obx(() {
                if (images.isEmpty) {
                  return const Center(child: Text('No photos provided..'));
                } else {
                  return SizedBox(
                    height: Get.height / 3,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          width: Get.width / 1.5, // Adjust as needed
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage(
                              placeholder:
                                  const AssetImage('assets/images/loading.gif'),
                              image: NetworkImage(images[index].file),
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration:
                                  const Duration(milliseconds: 300),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(RoutesUrls.jobCamera, arguments: jobOrder.id);
                },
                child: Text(
                  images.isEmpty ? 'Add Completion Photo' : 'Add more Photos',
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 238, 1)
                            .withOpacity(0.8)),
                    child: const Text('Send Feedback'))
              ])
            ],
          ),
        ),
      ),
    );
  }

  void onFilterPressed() {}
}
