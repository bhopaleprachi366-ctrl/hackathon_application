import 'package:flutter/material.dart';

class DeliveriesPage extends StatefulWidget {
  const DeliveriesPage({super.key});

  @override
  State<DeliveriesPage> createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> deliveries = [
    {
      'service': 'Fresh Milk',
      'category': 'Dairy',
      'date': '16 Aug 2026',
      'time': '7:00 AM - 9:00 AM',
      'quantity': '1 litre',
      'status': 'Upcoming',
      'icon': Icons.local_drink_outlined,
    },
    {
      'service': 'Drinking Water',
      'category': 'Water',
      'date': '20 Aug 2026',
      'time': '10:00 AM - 12:00 PM',
      'quantity': '2 cans',
      'status': 'Upcoming',
      'icon': Icons.water_drop_outlined,
    },
    {
      'service': 'Daily Tiffin',
      'category': 'Food',
      'date': '15 Aug 2026',
      'time': '12:00 PM - 2:00 PM',
      'quantity': '1 meal',
      'status': 'Delivered',
      'icon': Icons.restaurant_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDeliveries = selectedFilter == 'All'
        ? deliveries
        : deliveries
              .where((delivery) => delivery['status'] == selectedFilter)
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Deliveries',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: Row(
              children: [
                _filterButton('All'),
                const SizedBox(width: 10),
                _filterButton('Upcoming'),
                const SizedBox(width: 10),
                _filterButton('Delivered'),
              ],
            ),
          ),

          // Delivery Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filteredDeliveries.length} Deliveries',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
              ],
            ),
          ),

          // Delivery List
          Expanded(
            child: filteredDeliveries.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 20),
                    itemCount: filteredDeliveries.length,
                    itemBuilder: (context, index) {
                      return _deliveryCard(filteredDeliveries[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String filter) {
    final bool isSelected = selectedFilter == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = filter;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1565C0) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFE0E6ED),
            ),
          ),
          child: Center(
            child: Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF172B4D),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _deliveryCard(Map<String, dynamic> delivery) {
    final bool isDelivered = delivery['status'] == 'Delivered';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section
          Row(
            children: [
              Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FB),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  delivery['icon'],
                  color: const Color(0xFF1565C0),
                  size: 31,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery['service'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      delivery['category'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B778C),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      delivery['quantity'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),

              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: isDelivered
                      ? const Color(0xFFE8F6F3)
                      : const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  delivery['status'],
                  style: TextStyle(
                    color: isDelivered
                        ? const Color(0xFF008F7A)
                        : const Color(0xFFE67E22),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(height: 1),

          const SizedBox(height: 15),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 21,
                color: Color(0xFF1565C0),
              ),

              const SizedBox(width: 10),

              const Text(
                'Delivery Date',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B778C)),
              ),

              const Spacer(),

              Text(
                delivery['date'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Time
          Row(
            children: [
              const Icon(
                Icons.access_time_outlined,
                size: 21,
                color: Color(0xFF1565C0),
              ),

              const SizedBox(width: 10),

              const Text(
                'Delivery Time',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B778C)),
              ),

              const Spacer(),

              Text(
                delivery['time'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Track Button
          if (!isDelivered)
            SizedBox(
              width: double.infinity,
              height: 43,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showTrackingDialog(delivery);
                },
                icon: const Icon(Icons.location_on_outlined, size: 19),
                label: const Text('Track Delivery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '✓ Delivery Completed',
                  style: TextStyle(
                    color: Color(0xFF008F7A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_shipping_outlined,
              size: 80,
              color: Color(0xFFB0BEC5),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Deliveries Found',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your delivery information will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF6B778C)),
            ),
          ],
        ),
      ),
    );
  }

  void _showTrackingDialog(Map<String, dynamic> delivery) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Track Delivery'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                size: 55,
                color: Color(0xFF1565C0),
              ),

              const SizedBox(height: 15),

              Text(
                delivery['service'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Your delivery is scheduled and will be delivered soon.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6B778C)),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
