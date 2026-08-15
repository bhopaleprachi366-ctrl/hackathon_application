import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatelessWidget {
  final String name;
  final int price;
  final String frequency;
  final String category;
  final IconData icon;
  final String description;

  const ServiceDetailsPage({
    super.key,
    required this.name,
    required this.price,
    required this.frequency,
    required this.category,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                child: Icon(
                  icon,
                  size: 60,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "₹$price / $frequency",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 10),

            Chip(
              label: Text(category),
            ),

            const SizedBox(height: 20),

            const Text(
              "About this service",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Delivery",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Frequency: $frequency",
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Member 2 will connect SubscribePage here.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Subscribe page will be connected by Member 2",
                      ),
                    ),
                  );
                },
                child: const Text("Subscribe Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}