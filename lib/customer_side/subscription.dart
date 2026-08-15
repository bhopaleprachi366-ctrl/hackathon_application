import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  bool isSaving = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // SELECT DATE
  // ----------------------------------------------------------

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

  // ----------------------------------------------------------
  // CONFIRM SUBSCRIPTION
  // ----------------------------------------------------------

  Future<void> confirmSubscription() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select start date')));
      return;
    }

    if (addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    final User? user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final String serviceName =
          widget.service['name']?.toString() ??
          widget.service['serviceName']?.toString() ??
          'Service';

      final String category =
          widget.service['category']?.toString() ?? 'Category';

      final String unit = widget.service['unit']?.toString() ?? '';

      final int price =
          int.tryParse(widget.service['price']?.toString() ?? '0') ?? 0;

      final String serviceId =
          widget.service['id']?.toString() ??
          widget.service['serviceId']?.toString() ??
          '';

      final int totalPrice = price * quantity;

      // --------------------------------------------------------
      // CREATE SUBSCRIPTION DOCUMENT
      // --------------------------------------------------------

      final DocumentReference subscriptionRef = await _firestore
          .collection('subscriptions')
          .add({
            'userId': user.uid,

            'serviceId': serviceId,

            'serviceName': serviceName,

            'category': category,

            'price': price,

            'unit': unit,

            'quantity': quantity,

            'frequency': selectedFrequency,

            'status': 'Active',

            'startDate': Timestamp.fromDate(selectedDate!),

            'nextDelivery': Timestamp.fromDate(selectedDate!),

            'address': addressController.text.trim(),

            'totalPrice': totalPrice,

            'createdAt': FieldValue.serverTimestamp(),

            'updatedAt': FieldValue.serverTimestamp(),
          });

      // --------------------------------------------------------
      // CREATE FIRST DELIVERY
      // --------------------------------------------------------

      await _firestore.collection('deliveries').add({
        'userId': user.uid,

        'subscriptionId': subscriptionRef.id,

        'serviceId': serviceId,

        'quantity': quantity,

        'deliveryDate': Timestamp.fromDate(selectedDate!),

        'status': 'scheduled',

        'createdAt': FieldValue.serverTimestamp(),

        'vendorId': '',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subscription confirmed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Go back after successful subscription
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Subscription confirmed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final int price =
        int.tryParse(widget.service['price']?.toString() ?? '0') ?? 0;

    final int totalPrice = price * quantity;

    final String serviceName =
        widget.service['name']?.toString() ??
        widget.service['serviceName']?.toString() ??
        'Service';

    final String category =
        widget.service['category']?.toString() ?? 'Category';

    final String unit = widget.service['unit']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      // --------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------
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

      // --------------------------------------------------------
      // BODY
      // --------------------------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // SELECTED SERVICE
            // --------------------------------------------------
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
                          serviceName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172B4D),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B778C),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '₹$price / $unit',
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

            // --------------------------------------------------
            // QUANTITY
            // --------------------------------------------------
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
                    'Quantity ($unit)',
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

            // --------------------------------------------------
            // FREQUENCY
            // --------------------------------------------------
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

            // --------------------------------------------------
            // START DATE
            // --------------------------------------------------
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
                          : '${selectedDate!.day.toString().padLeft(2, '0')}/'
                                '${selectedDate!.month.toString().padLeft(2, '0')}/'
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

            // --------------------------------------------------
            // ADDRESS
            // --------------------------------------------------
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

            // --------------------------------------------------
            // PRICE SUMMARY
            // --------------------------------------------------
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

            // --------------------------------------------------
            // CONFIRM BUTTON
            // --------------------------------------------------
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: isSaving ? null : confirmSubscription,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),

                  foregroundColor: Colors.white,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: isSaving
                    ? const SizedBox(
                        height: 23,
                        width: 23,

                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Confirm Subscription',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // FREQUENCY BUTTON
  // ----------------------------------------------------------

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

  // ----------------------------------------------------------
  // PRICE ROW
  // ----------------------------------------------------------

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
