// import 'dart:convert';

// import 'package:firstapp/controllers/auth.dart';
// import 'package:firstapp/models/customer.dart';
// import 'package:firstapp/pages/customers/components/customer_card.dart';
// import 'package:firstapp/pages/home_page/components/home_appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:firstapp/pages/customers/components/search_bar.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class CustomersPage extends StatefulWidget {
//   const CustomersPage({Key? key}) : super(key: key);

//   @override
//   _CustomerPageState createState() => _CustomerPageState();
// }

// class _CustomerPageState extends State<CustomersPage> {
//   final AuthController authController = Get.find();
//   final RxList<Customer> customers = <Customer>[].obs;
//   final RxBool emptyQuery = false.obs;
//   TextEditingController query = TextEditingController();
//   int currentPage = 1;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     getCustomers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: HomeAppBar(),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Customers Page',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             ServicesSearchBar(
//               onSearchPressed: onSearchPressed,
//               onFilterPressed: onFilterPressed,
//               searchController: query,
//             ),
//             const SizedBox(height: 16.0),
//             Expanded(
//               child: Obx(() {
//                 if (customers.isEmpty && !emptyQuery.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (emptyQuery.value) {
//                   return const Center(child: Text('No results found.'));
//                 } else {
//                   return ListView.builder(
//                     itemCount: customers.length,
//                     itemBuilder: (context, index) {
//                       final customer = customers[index];
//                       return CustomerCard(customer: customer);
//                     },
//                   );
//                 }
//               }),
//             ),
//             SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed:
//                       currentPage > 1 ? () => loadPage(currentPage - 1) : null,
//                   child: Text('Previous Page'),
//                 ),
//                 SizedBox(width: 16.0),
//                 Text('Page $currentPage'),
//                 SizedBox(width: 16.0),
//                 ElevatedButton(
//                   onPressed: customers.isNotEmpty
//                       ? () => loadPage(currentPage + 1)
//                       : null,
//                   child: Text('Next Page'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void onSearchPressed(String search) {
//     print('Search pressed with query: $search');
//     getCustomers(search: search);
//   }

//   void onFilterPressed() {
//     print('Filter pressed');
//   }

//   Future<void> getCustomers({String search = ''}) async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final response = await http.get(
//         Uri.parse(
//             '${dotenv.env['API_BASE_URL']}customers/?search=$search&page=$currentPage'),
//         headers: {'Authorization': 'Token ${authController.token}'},
//       );

//       setState(() {
//         isLoading = false;
//       });

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         final List<dynamic> results = responseData['results'];
//         // Update customers list
//         customers.assignAll(
//             results.map((customerJson) => Customer.fromJson(customerJson)));
//       } else {
//         throw Exception('Failed to get customers.');
//       }
//     } catch (e) {
//       print('Error fetching customers: $e');
//       rethrow;
//     }
//   }

//   void loadPage(int page) {
//     currentPage = page;
//     getCustomers();
//   }
// }
