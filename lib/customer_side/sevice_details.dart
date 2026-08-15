import 'package:flutter/material.dart';
import 'package:hackathon_application/customer_side/subscription.dart';

class ServiceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        title: const Text(
          'Service Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image / Icon
            Container(
              width: double.infinity,
              height: 230,
              color: const Color(0xFFE8F1FB),
              child: Icon(
                service['icon'] ?? Icons.miscellaneous_services_outlined,
                size: 90,
                color: const Color(0xFF1565C0),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Name
                  Text(
                    service['name'] ?? 'Service Name',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F6F3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      service['category'] ?? 'Category',
                      style: const TextStyle(
                        color: Color(0xFF008F7A),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Price
                  Row(
                    children: [
                      Text(
                        '₹${service['price'] ?? 0}',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      Text(
                        ' / ${service['unit'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B778C),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Description
                  const Text(
                    'About this service',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    service['description'] ??
                        'This service is available for regular subscription and doorstep delivery.',
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF6B778C),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Frequency
                  const Text(
                    'Available Frequency',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _frequencyChip('Daily'),
                      const SizedBox(width: 10),
                      _frequencyChip('Weekly'),
                      const SizedBox(width: 10),
                      _frequencyChip('Monthly'),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Vendor
                  const Text(
                    'Service Provider',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFFE8F1FB),
                          child: Icon(
                            Icons.store_outlined,
                            color: Color(0xFF1565C0),
                          ),
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SubServe Provider',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF172B4D),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Trusted service provider',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B778C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Subscribe Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SubscriptionPage(service: service),
                          ),
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
                        'Subscribe Now',
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
          ],
        ),
      ),
    );
  }

  static Widget _frequencyChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD7E2EF)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF172B4D),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
