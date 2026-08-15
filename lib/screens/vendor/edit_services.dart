import 'package:flutter/material.dart';

class EditServicePage extends StatefulWidget {
  final String serviceName;
  final String category;
  final String description;
  final String price;

  const EditServicePage({
    super.key,
    required this.serviceName,
    required this.category,
    required this.description,
    required this.price,
  });

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _serviceNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  String? selectedCategory;

  final List<String> categories = [
    'Cleaning',
    'Laundry',
    'Food Delivery',
    'Car Wash',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    _serviceNameController =
        TextEditingController(text: widget.serviceName);

    _descriptionController =
        TextEditingController(text: widget.description);

    _priceController =
        TextEditingController(text: widget.price);

    selectedCategory = widget.category;
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateService() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service updated successfully!'),
          backgroundColor: Color(0xFF2563EB),
        ),
      );

      Navigator.pop(context);
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
          'Edit Service',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
                'Edit Service Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Update your service information.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
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
                value: selectedCategory,
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

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _updateService,
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Update Service',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
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
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: Icon(
        icon,
        color: const Color(0xFF2563EB),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF2563EB),
          width: 1.5,
        ),
      ),
    );
  }
}