import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hackathon_application/customer_side/services.dart';
import 'package:hackathon_application/customer_side/my_subscriptions.dart';
import 'package:hackathon_application/customer_side/sevice_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  String searchText = '';

  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FIREBASE - FETCH SERVICES
  // ============================================================

  Future<void> fetchServices() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('availability', isEqualTo: true)
          .limit(3)
          .get();

      final fetchedServices = snapshot.docs.map((doc) {
        final data = doc.data();

        final String category = data['category']?.toString() ?? '';

        return {
          'id': doc.id,
          'name': data['serviceName']?.toString() ?? '',
          'category': category,
          'price': data['price'] ?? 0,
          'unit': data['unit']?.toString() ?? '',
          'description': data['description']?.toString() ?? '',
          'frequencyOptions': List<String>.from(data['frequencyOptions'] ?? []),
          'availability': data['availability'] ?? false,
          'vendorId': data['vendorId']?.toString() ?? '',
          'createdAt': data['createdAt'],
          'icon': getServiceIcon(category),
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        services = fetchedServices;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Home Firebase Error: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to load services')));
    }
  }

  // ============================================================
  // SERVICE ICON
  // ============================================================

  IconData getServiceIcon(dynamic category) {
    final String safeCategory = category == null
        ? ''
        : category.toString().trim().toLowerCase();

    switch (safeCategory) {
      case 'dairy':
        return Icons.local_drink_outlined;

      case 'water':
        return Icons.water_drop_outlined;

      case 'food':
        return Icons.restaurant_outlined;

      case 'newspaper':
        return Icons.menu_book_outlined;

      case 'vegetables':
        return Icons.eco_outlined;

      default:
        return Icons.miscellaneous_services_outlined;
    }
  }
  // ============================================================
  // OPEN SERVICES PAGE
  // ============================================================

  void openServicesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServicesPage()),
    );
  }

  // ============================================================
  // OPEN SUBSCRIPTIONS PAGE
  // ============================================================

  void openSubscriptionsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MySubscriptionPage()),
    );
  }

  // ============================================================
  // OPEN SERVICE DETAILS
  // ============================================================

  void openServiceDetails(Map<String, dynamic> service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsPage(service: service),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final filteredServices = services.where((service) {
      final name = service['name'].toString().toLowerCase();

      final category = service['category'].toString().toLowerCase();

      final search = searchText.toLowerCase().trim();

      if (search.isEmpty) {
        return true;
      }

      return name.contains(search) || category.contains(search);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        automaticallyImplyLeading: false,

        title: const Text(
          'SubServe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: RefreshIndicator(
        color: const Color(0xFF1565C0),

        onRefresh: fetchServices,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // GREETING
              // ==================================================
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

              // ==================================================
              // SEARCH BAR
              // ==================================================
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

                child: TextField(
                  controller: searchController,

                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },

                  decoration: const InputDecoration(
                    hintText: 'Search services...',

                    hintStyle: TextStyle(color: Color(0xFF9AA5B1)),

                    prefixIcon: Icon(Icons.search, color: Color(0xFF1565C0)),

                    border: InputBorder.none,

                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // MY SUBSCRIPTION
              // ==================================================
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
                    onPressed: openSubscriptionsPage,

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

              // ==================================================
              // SUBSCRIPTION CARD
              // ==================================================
              GestureDetector(
                onTap: openSubscriptionsPage,

                child: Container(
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

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              'Next delivery: Tomorrow',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
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
              ),

              const SizedBox(height: 28),

              // ==================================================
              // CATEGORIES
              // ==================================================
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

                    _categoryCard(
                      icon: Icons.restaurant_outlined,
                      title: 'Food',
                    ),

                    _categoryCard(
                      icon: Icons.menu_book_outlined,
                      title: 'Newspaper',
                    ),

                    _categoryCard(
                      icon: Icons.eco_outlined,
                      title: 'Vegetables',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // AVAILABLE SERVICES TITLE
              // ==================================================
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
                    onPressed: openServicesPage,

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

              // ==================================================
              // FIREBASE SERVICES
              // ==================================================
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),

                    child: CircularProgressIndicator(color: Color(0xFF1565C0)),
                  ),
                )
              else if (filteredServices.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),

                    child: Text(
                      'No services available',

                      style: TextStyle(color: Color(0xFF6B778C), fontSize: 15),
                    ),
                  ),
                )
              else
                ...filteredServices.map((service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),

                    child: _serviceCard(service: service),
                  );
                }),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY CARD
  // ============================================================

  Widget _categoryCard({required IconData icon, required String title}) {
    return GestureDetector(
      onTap: openServicesPage,

      child: Container(
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
      ),
    );
  }

  // ============================================================
  // SERVICE CARD
  // ============================================================

  Widget _serviceCard({required Map<String, dynamic> service}) {
    return GestureDetector(
      onTap: () {
        openServiceDetails(service);
      },

      child: Container(
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
            // ==================================================
            // ICON
            // ==================================================
            Container(
              height: 58,
              width: 58,

              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FB),

                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(
                service['icon'] as IconData,

                color: const Color(0xFF1565C0),

                size: 30,
              ),
            ),

            const SizedBox(width: 14),

            // ==================================================
            // SERVICE INFO
            // ==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    service['name'],

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    service['category'],

                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B778C),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // PRICE
            // ==================================================
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,

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
                  '/ ${service['unit']}',

                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B778C),
                  ),
                ),

                const SizedBox(height: 4),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 13,
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
