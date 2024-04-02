import 'package:crm/api/service_api_services.dart';
import 'package:crm/controllers/auth.dart';
import 'package:crm/settings/routes_urls.dart';
import 'package:crm/validators/services_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/service.dart';

class EditService extends StatefulWidget {
  const EditService({super.key});

  @override
  State<EditService> createState() => _CreateServiceState();
}

class _CreateServiceState extends State<EditService> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find();

  late final Service service;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _nameController;
  late final TextEditingController _durationMonthsController;

  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize Service object and associated controllers
    service = ModalRoute.of(context)!.settings.arguments as Service;
    _nameController = TextEditingController(text: service.name);
    _descriptionController = TextEditingController(text: service.description);
    _priceController = TextEditingController(text: service.price.toString());
    _durationMonthsController =
        TextEditingController(text: service.durationMonths.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: nameValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: descriptionValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Price \$',
                  border: OutlineInputBorder(),
                ),
                validator: priceValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationMonthsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Duration (in months)',
                  border: OutlineInputBorder(),
                ),
                validator: durationMonthsValidator,
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

      try {
        final success = await handleUpdateService(
            name: _nameController.text,
            description: _descriptionController.text,
            price: _priceController.text,
            durationMonths: _durationMonthsController.text,
            token: authController.token,
            serviceId: service.id);
        setState(() {
          _isLoading = false;
        });

        if (success != false) {
          Get.offNamedUntil(RoutesUrls.serviceDetails,
              (route) => route.settings.name == RoutesUrls.servicesPage,
              arguments: Service.fromJson(success));
          Get.snackbar(
            'Success',
            'Service successfully updated!',
            backgroundColor: const Color.fromARGB(255, 71, 120, 73),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
