import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_application/customer_side/sevice_details.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String selectedCategory = 'All';
  String searchText = '';

  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> services = [];

  final List<String> categories = [
    'All',
    'Dairy',
    'Water',
    'Food',
    'Newspaper',
    'Vegetables',
  ];

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

  // ==========================================================
  // FETCH SERVICES FROM FIREBASE
  // ==========================================================

  Future<void> fetchServices() async {
    try {
      debugPrint('Fetching services from Firestore...');

      // IMPORTANT:
      // Firestore field name must be "availability"
      final snapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('availability', isEqualTo: true)
          .get();
      debugPrint('Total available documents: ${snapshot.docs.length}');

      final List<Map<String, dynamic>> fetchedServices = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        debugPrint('Document ID: ${doc.id}');
        debugPrint('Document data: $data');

        final String category = data['category']?.toString() ?? '';

        final dynamic frequencyData = data['frequencyOptions'];

        List<String> frequencyOptions = [];

        if (frequencyData is List) {
          frequencyOptions = frequencyData
              .map((item) => item.toString())
              .toList();
        }

        fetchedServices.add({
          'id': doc.id,

          'name': data['serviceName']?.toString() ?? 'Service',

          'category': category,

          'price': data['price'] ?? 0,

          'unit': data['unit']?.toString() ?? '',

          'description': data['description']?.toString() ?? '',

          'frequencyOptions': frequencyOptions,

          'availability': data['availability'] ?? false,

          'vendorId': data['vendorId']?.toString() ?? '',

          'createdAt': data['createdAt'],

          'icon': getServiceIcon(category),
        });
      }

      debugPrint('Available services: ${fetchedServices.length}');

      if (!mounted) return;

      setState(() {
        services = fetchedServices;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching services: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to load services: $e')));
    }
  }

  // ==========================================================
  // SERVICE ICON
  // ==========================================================

  IconData getServiceIcon(String category) {
    switch (category.toLowerCase()) {
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

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final String search = searchText.toLowerCase().trim();

    final filteredServices = services.where((service) {
      final String serviceCategory = service['category'].toString();

      final bool categoryMatch =
          selectedCategory == 'All' || serviceCategory == selectedCategory;

      final String name = service['name'].toString().toLowerCase();

      final String category = serviceCategory.toLowerCase();

      final bool searchMatch =
          search.isEmpty || name.contains(search) || category.contains(search);

      return categoryMatch && searchMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        automaticallyImplyLeading: false,

        title: const Text(
          'Services',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            )
          : Column(
              children: [
                // ==================================================
                // SEARCH BAR
                // ==================================================
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

                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF1565C0),
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // CATEGORIES
                // ==================================================
                SizedBox(
                  height: 55,

                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    scrollDirection: Axis.horizontal,

                    itemCount: categories.length,

                    itemBuilder: (context, index) {
                      final category = categories[index];

                      final bool isSelected = selectedCategory == category;

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

                // ==================================================
                // SERVICES COUNT
                // ==================================================
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

                // ==================================================
                // SERVICE LIST
                // ==================================================
                Expanded(
                  child: filteredServices.isEmpty
                      ? const Center(
                          child: Text(
                            'No services available',
                            style: TextStyle(
                              color: Color(0xFF6B778C),
                              fontSize: 16,
                            ),
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

  // ==========================================================
  // SERVICE CARD
  // ==========================================================

  Widget _serviceCard({required Map<String, dynamic> service}) {
    final List<dynamic> frequencies = service['frequencyOptions'] ?? [];

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
            // ==================================================
            // ICON
            // ==================================================
            Container(
              height: 72,
              width: 72,

              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FB),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(
                service['icon'] as IconData,
                color: const Color(0xFF1565C0),
                size: 34,
              ),
            ),

            const SizedBox(width: 14),

            // ==================================================
            // SERVICE INFORMATION
            // ==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    service['name'].toString(),

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    service['category'].toString(),

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

            const SizedBox(width: 8),

            // ==================================================
            // FREQUENCY + ARROW
            // ==================================================
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                if (frequencies.isNotEmpty)
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
                      _displayFrequency(frequencies),

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

  // ==========================================================
  // FREQUENCY TEXT
  // ==========================================================

  String _displayFrequency(List<dynamic> frequencies) {
    if (frequencies.isEmpty) {
      return '';
    }

    final String first = frequencies.first.toString();

    if (first.isEmpty) {
      return '';
    }

    return first[0].toUpperCase() + first.substring(1);
  }
}
