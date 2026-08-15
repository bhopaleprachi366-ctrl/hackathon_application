import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'SubServe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Open notifications page
            },
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const Text(
              'Good Morning 👋',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Manage your subscriptions easily.',
              style: TextStyle(fontSize: 15, color: Color(0xFF6B778C)),
            ),

            const SizedBox(height: 22),

            // Search bar
            Container(
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

            const SizedBox(height: 25),

            // Active Subscription
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Subscription',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Open My Subscriptions
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF00A896)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    height: 58,
                    width: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.local_drink_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fresh Milk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '1 L • Daily',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Next delivery: Tomorrow',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Categories
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 95,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _categoryCard(
                    icon: Icons.local_drink_outlined,
                    title: 'Dairy',
                  ),

                  _categoryCard(
                    icon: Icons.water_drop_outlined,
                    title: 'Water',
                  ),

                  _categoryCard(icon: Icons.restaurant_outlined, title: 'Food'),

                  _categoryCard(
                    icon: Icons.menu_book_outlined,
                    title: 'Newspaper',
                  ),

                  _categoryCard(icon: Icons.eco_outlined, title: 'Vegetables'),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Available Services
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Services',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Open Services page
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Service Card 1
            _serviceCard(
              icon: Icons.local_drink_outlined,
              title: 'Fresh Milk',
              category: 'Dairy',
              price: '₹40',
              unit: '/ litre',
            ),

            const SizedBox(height: 12),

            // Service Card 2
            _serviceCard(
              icon: Icons.water_drop_outlined,
              title: 'Drinking Water',
              category: 'Water',
              price: '₹80',
              unit: '/ can',
            ),

            const SizedBox(height: 12),

            // Service Card 3
            _serviceCard(
              icon: Icons.restaurant_outlined,
              title: 'Daily Tiffin',
              category: 'Food',
              price: '₹100',
              unit: '/ day',
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),

      // Bottom navigation
    );
  }

  // Category card
  static Widget _categoryCard({required IconData icon, required String title}) {
    return Container(
      width: 82,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF1565C0), size: 28),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172B4D),
            ),
          ),
        ],
      ),
    );
  }

  // Service card
  static Widget _serviceCard({
    required IconData icon,
    required String title,
    required String category,
    required String price,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
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
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF1565C0), size: 30),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B778C),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              Text(
                unit,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B778C)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
