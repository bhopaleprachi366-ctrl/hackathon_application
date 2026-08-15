import 'package:flutter/material.dart';
import 'package:hackathon_application/customer_side/sevice_details.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Dairy',
    'Water',
    'Food',
    'Newspaper',
    'Vegetables',
  ];

  final List<Map<String, dynamic>> services = [
    {
      'name': 'Fresh Milk',
      'category': 'Dairy',
      'price': 40,
      'unit': 'litre',
      'frequency': 'Daily',
      'icon': Icons.local_drink_outlined,
    },
    {
      'name': 'Drinking Water',
      'category': 'Water',
      'price': 80,
      'unit': 'can',
      'frequency': 'Weekly',
      'icon': Icons.water_drop_outlined,
    },
    {
      'name': 'Daily Tiffin',
      'category': 'Food',
      'price': 100,
      'unit': 'day',
      'frequency': 'Daily',
      'icon': Icons.restaurant_outlined,
    },
    {
      'name': 'Morning Newspaper',
      'category': 'Newspaper',
      'price': 150,
      'unit': 'month',
      'frequency': 'Monthly',
      'icon': Icons.menu_book_outlined,
    },
    {
      'name': 'Fresh Vegetable Box',
      'category': 'Vegetables',
      'price': 300,
      'unit': 'box',
      'frequency': 'Weekly',
      'icon': Icons.eco_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredServices = selectedCategory == 'All'
        ? services
        : services
              .where((service) => service['category'] == selectedCategory)
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        title: const Text(
          'Services',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle: TextStyle(color: Color(0xFF9AA5B1)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF1565C0)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 55,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1565C0)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFE0E6ED),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF172B4D),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Services Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${filteredServices.length} Services Available',
                  style: const TextStyle(
                    color: Color(0xFF172B4D),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Service List
          Expanded(
            child: filteredServices.isEmpty
                ? const Center(
                    child: Text(
                      'No services available',
                      style: TextStyle(color: Color(0xFF6B778C), fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];

                      return _serviceCard(service: service);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard({required Map<String, dynamic> service}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsPage(service: service),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
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
            // Icon Container
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                service['icon'],
                color: const Color(0xFF1565C0),
                size: 34,
              ),
            ),

            const SizedBox(width: 14),

            // Service Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    service['category'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B778C),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        '₹${service['price']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      Text(
                        ' / ${service['unit']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B778C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Frequency + Arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F6F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    service['frequency'],
                    style: const TextStyle(
                      color: Color(0xFF008F7A),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF1565C0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
