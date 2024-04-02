import 'package:crm/api/customer_api_services.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/models/customer.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:crm/validators/customer_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCustomer extends StatefulWidget {
  const EditCustomer({super.key});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneNumberController;
  late final Customer customer;

  final List<String> _cities = [
    "Gaza",
    "Nablus",
    "Quds",
    "Al-Khalil",
    "Ramallah",
    "Bethlehem",
    "Tulkarem",
    "Jinen",
  ];

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    customer = ModalRoute.of(context)!.settings.arguments as Customer;
    _firstNameController = TextEditingController(text: customer.firstName);
    _lastNameController = TextEditingController(text: customer.lastName);
    _addressController = TextEditingController(text: customer.address);
    _phoneNumberController = TextEditingController(text: customer.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: firstNameValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: lastNameValidator,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _addressController.text,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                items: _cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _addressController.text = newValue ?? '';
                },
                validator: addressValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: phoneNumberValidator,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final success = await handleUpdateCustomer(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          address: _addressController.text,
          phoneNumber: _phoneNumberController.text,
          token: authController.token,
          customerId: customer.id);

      setState(() {
        _isLoading = false;
      });

      if (success != false) {
        Get.offNamedUntil(RoutesUrls.customerDetails,
            (route) => route.settings.name == RoutesUrls.customersPage,
            arguments: Customer.fromJson(success));
        Get.snackbar(
          'Success',
          'Customer successfully created!',
          backgroundColor: const Color.fromARGB(255, 71, 120, 73),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }
}
