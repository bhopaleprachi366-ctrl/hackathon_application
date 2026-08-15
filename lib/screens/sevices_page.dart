import 'package:flutter/material.dart';

import 'service_details_page.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const List<Map<String, dynamic>> services = [
    {
      "name": "Fresh Milk",
      "price": 40,
      "frequency": "Daily",
      "category": "Food",
      "icon": Icons.local_drink,
      "description":
          "Fresh milk delivered to your doorstep every morning.",
    },
    {
      "name": "Newspaper",
      "price": 10,
      "frequency": "Daily",
      "category": "Newspaper",
      "icon": Icons.newspaper,
      "description":
          "Get your newspaper delivered to your doorstep every morning.",
    },
    {
      "name": "Water Can",
      "price": 80,
      "frequency": "Weekly",
      "category": "Water",
      "icon": Icons.water_drop,
      "description":
          "Clean drinking water delivered to your home every week.",
    },
    {
      "name": "Tiffin",
      "price": 100,
      "frequency": "Daily",
      "category": "Food",
      "icon": Icons.restaurant,
      "description":
          "Fresh and healthy homemade meals delivered daily.",
    },
    {
      "name": "Vegetable Box",
      "price": 300,
      "frequency": "Weekly",
      "category": "Vegetables",
      "icon": Icons.eco,
      "description":
          "Fresh vegetables delivered directly to your doorstep.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),

              leading: CircleAvatar(
                radius: 28,
                child: Icon(service["icon"]),
              ),

              title: Text(
                service["name"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                "₹${service["price"]} • ${service["frequency"]}\n"
                "${service["category"]}",
              ),

              isThreeLine: true,

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailsPage(
                      name: service["name"],
                      price: service["price"],
                      frequency: service["frequency"],
                      category: service["category"],
                      icon: service["icon"],
                      description: service["description"],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}