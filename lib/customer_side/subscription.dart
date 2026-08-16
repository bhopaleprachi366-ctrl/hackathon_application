import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  final Map<String, dynamic> service;

  const SubscriptionPage({super.key, required this.service});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int quantity = 1;
  String selectedFrequency = 'Daily';
  DateTime? selectedDate;

  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int price = widget.service['price'] ?? 0;
    final int totalPrice = price * quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        title: const Text(
          'Subscribe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Service
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FB),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      widget.service['icon'] ??
                          Icons.miscellaneous_services_outlined,
                      color: const Color(0xFF1565C0),
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.service['name'] ?? 'Service',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172B4D),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          widget.service['category'] ?? 'Category',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B778C),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '₹$price / ${widget.service['unit'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Quantity
            const Text(
              'Quantity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantity (${widget.service['unit'] ?? 'unit'})',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        onPressed: quantity > 1
                            ? () {
                                setState(() {
                                  quantity--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: const Color(0xFF1565C0),
                      ),

                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color(0xFF1565C0),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Frequency
            const Text(
              'Delivery Frequency',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              children: [
                _frequencyButton('Daily'),
                _frequencyButton('Weekly'),
                _frequencyButton('Monthly'),
              ],
            ),

            const SizedBox(height: 25),

            // Start Date
            const Text(
              'Start Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: selectDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFE0E6ED)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF1565C0),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      selectedDate == null
                          ? 'Select start date'
                          : '${selectedDate!.day}/'
                                '${selectedDate!.month}/'
                                '${selectedDate!.year}',
                      style: TextStyle(
                        fontSize: 15,
                        color: selectedDate == null
                            ? const Color(0xFF9AA5B1)
                            : const Color(0xFF172B4D),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Address
            const Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your delivery address',
                hintStyle: const TextStyle(color: Color(0xFF9AA5B1)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 35),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF1565C0),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Price Summary
            const Text(
              'Price Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _priceRow('Price', '₹$price'),

                  const SizedBox(height: 10),

                  _priceRow('Quantity', '$quantity'),

                  const Divider(height: 25),

                  _priceRow('Total', '₹$totalPrice', isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedDate == null ||
                      addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select date and enter address'),
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subscription confirmed!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Confirm Subscription',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _frequencyButton(String frequency) {
    final bool isSelected = selectedFrequency == frequency;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFrequency = frequency;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1565C0)
                : const Color(0xFFE0E6ED),
          ),
        ),
        child: Text(
          frequency,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF172B4D),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 17 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF172B4D),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xFF1565C0) : const Color(0xFF172B4D),
          ),
        ),
      ],
    );
  }
}
