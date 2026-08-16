import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _serviceNameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  String? selectedCategory;

  final List<String> categories = [
    'Cleaning',
    'Laundry',
    'Food Delivery',
    'Car Wash',
    'Other',
  ];

  @override
  void dispose() {
    _serviceNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _addService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser;

if (user == null) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Please login first'),
      backgroundColor: Colors.red,
    ),
  );
  return;
}

    try {
      await FirebaseFirestore.instance.collection('service').add({
        'name': _serviceNameController.text.trim(),
        'category': selectedCategory,
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'vendorId': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service added successfully!'),
          backgroundColor: Color(0xFF2563EB),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Add Service',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create New Service',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              const Text(
                'Add details about the service you provide.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              // Service Name
              _buildLabel('Service Name'),

              const SizedBox(height: 8),

              TextFormField(
                controller: _serviceNameController,
                decoration: _inputDecoration(
                  hintText: 'Enter service name',
                  icon: Icons.miscellaneous_services_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter service name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Category
              _buildLabel('Category'),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: _inputDecoration(
                  hintText: 'Select category',
                  icon: Icons.category_outlined,
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select category';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Description
              _buildLabel('Description'),

              const SizedBox(height: 8),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration(
                  hintText: 'Describe your service',
                  icon: Icons.description_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Price
              _buildLabel('Price'),

              const SizedBox(height: 8),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  hintText: 'Enter price',
                  icon: Icons.currency_rupee,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Add Service Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addService,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Service',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: const Icon(Icons.circle, color: Colors.transparent, size: 0),
      suffixIcon: Icon(icon, color: const Color(0xFF2563EB)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
    );
  }
}
