import 'package:crm/controllers/job_order.dart';
import 'package:crm/models/job_order.dart';
import 'package:crm/pages/job_order_details/components/job_map.dart';
import 'package:crm/pages/job_order_details/components/job_order_card_details.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/components/appbar/home_appbar.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobOrderDetails extends StatefulWidget {
  const JobOrderDetails({super.key});

  @override
  State<JobOrderDetails> createState() => _JobOrderDetailsState();
}

class _JobOrderDetailsState extends State<JobOrderDetails> {
  final AuthController authController = Get.find();
  final JobOrderController jobOrderController = Get.find();
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: jobOrderController.fetchJobOrders,
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                final JobOrder jobOrder =
                    jobOrderController.selectedJobOrder.value!;
                feedbackController.text = jobOrder.feedback;
                return Column(
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
                    if (jobOrder.images.isEmpty)
                      const Center(child: Text('No photos provided..'))
                    else
                      SizedBox(
                        height: Get.height / 3,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: jobOrder.images.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              width: Get.width / 1.5, // Adjust as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      'assets/images/loading.gif'),
                                  image:
                                      NetworkImage(jobOrder.images[index].file),
                                  fit: BoxFit.cover,
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 300),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    Column(children: [
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(RoutesUrls.jobCamera,
                              arguments: jobOrder.id);
                        },
                        child: Text(
                          jobOrder.images.isEmpty
                              ? 'Add Completion Photo'
                              : 'Add more Photos',
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
                      if (jobOrder.feedback.isNotEmpty)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Feedback already provided',
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            Icon(
                              Icons.feedback,
                              color: Colors.green,
                            )
                          ],
                        ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      TextField(
                        maxLines: 3,
                        enabled: jobOrder.feedback.isEmpty,
                        controller: feedbackController,
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
                      const SizedBox(height: 16),
                      const SizedBox(height: 20),
                      if (jobOrder.feedback.isEmpty)
                        ElevatedButton(
                            onPressed: () => {
                                  if (feedbackController.text.isNotEmpty)
                                    jobOrderController.addFeedback(
                                        jobOrder.id,
                                        authController.token,
                                        feedbackController.text),
                                },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 238, 1)
                                        .withOpacity(0.8)),
                            child: const Text('Send Feedback')),
                      if (jobOrder.feedback.isNotEmpty)
                        const Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 12),
                      if (jobOrder.feedback.isNotEmpty)
                        TextField(
                          controller: commentController,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.grey[400],
                            ),
                            hintText: 'Comment here...',
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
                      const SizedBox(height: 6),
                      if (jobOrder.comments.isNotEmpty)
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            // shrinkWrap: true,
                            itemCount: jobOrder.comments.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Avatar and username section
                                    Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      child: CircleAvatar(
                                        // You can set the image here
                                        child: Text(jobOrder.comments[index]
                                            .createdBy.username[0]),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Username
                                        Text(
                                          jobOrder.comments[index].createdBy
                                              .username,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // Comment
                                        Text(
                                          jobOrder.comments[index].body,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // Commented time
                                        Text(
                                          'Commented ${formatTimeAgo(jobOrder.comments[index].createdAt)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      if (jobOrderController
                          .selectedJobOrder.value!.feedback.isNotEmpty)
                        Column(children: [
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              if (commentController.text.isNotEmpty) {
                                await jobOrderController.addComment(
                                    jobOrder.id,
                                    authController.token,
                                    commentController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 159, 228, 193)
                                      .withOpacity(0.8),
                            ),
                            child: const Text('Add Comment'),
                          ),
                          const SizedBox(height: 16)
                        ])
                    ])
                  ],
                );
              })),
        ),
      ),
    );
  }

  String formatTimeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 365) {
      int years = (difference.inDays / 365).floor();
      return '${years} year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays >= 30) {
      int months = (difference.inDays / 30).floor();
      return '${months} month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
