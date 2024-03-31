import 'package:crm/controllers/job_order.dart';
import 'package:crm/components/appbar/home_appbar.dart';
import 'package:crm/pages/job_orders/components/job_order_card.dart';
import 'package:flutter/material.dart';
import 'package:crm/pages/job_orders/components/search_bar.dart';
import 'package:get/get.dart';

class JobOrderPage extends StatefulWidget {
  const JobOrderPage({super.key});

  @override
  _JobOrderPageState createState() => _JobOrderPageState();
}

class _JobOrderPageState extends State<JobOrderPage> {
  final JobOrderController jobOrderController = Get.put(JobOrderController());
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final query = jobOrderController.query;
    final jobOrders = jobOrderController.jobOrders;

    return Scaffold(
      appBar: HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: jobOrderController.fetchJobOrders,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Job Orders',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  JobOrdersSearchBar(
                    onSearchPressed: onSearchPressed,
                    onFilterPressed: onFilterPressed,
                    searchController: query,
                  ),
                  const SizedBox(height: 16.0),
                  Obx(() {
                    if (jobOrderController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (jobOrderController.query.text.isEmpty &&
                        jobOrderController.jobOrders.isEmpty) {
                      return const Center(child: Text('No results found.'));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: jobOrders.length,
                        itemBuilder: (context, index) {
                          final jobOrder = jobOrders[index];
                          return JobOrderCard(jobOrder: jobOrder);
                        },
                      );
                    }
                  }),
                  _buildPaginationControls(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final count = jobOrderController.count;
    final currentPage = jobOrderController.currentPage;
    final pageSize = jobOrderController.pageSize;
    int totalPages = (count / pageSize).ceil();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentPage > 1 ? () => goToPage(1) : null,
              child: const Text('<<'),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: currentPage > 1 ? () => changePage(-1) : null,
              child: const Text('<'),
            ),
            const SizedBox(width: 8.0),
            Text('Page $currentPage of $totalPages'),
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: currentPage < totalPages ? () => changePage(1) : null,
              child: const Text('>'),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed:
                  currentPage < totalPages ? () => goToPage(totalPages) : null,
              child: const Text('>>'),
            ),
          ],
        ),
      ),
    );
  }

  void goToPage(int page) {
    setState(() {
      currentPage = page;
      jobOrderController.currentPage = page;
      jobOrderController.fetchJobOrders();
    });
  }

  void changePage(int pageChange) {
    setState(() {
      currentPage += pageChange;
      jobOrderController.currentPage += pageChange;
      jobOrderController.fetchJobOrders();
    });
  }

  void onSearchPressed(String search) {
    // Simulate search functionality
    print('Search pressed with query: $search');
    jobOrderController.query.text = search;
    jobOrderController.fetchJobOrders();
  }

  void onFilterPressed() {
    // Simulate filter functionality
    // print('Filter pressed');
  }
}
