import 'package:flutter/material.dart';

class MySubscriptionsPage extends StatefulWidget {
  const MySubscriptionsPage({super.key});

  @override
  State<MySubscriptionsPage> createState() => _MySubscriptionsPageState();
}

class _MySubscriptionsPageState extends State<MySubscriptionsPage> {
  final List<Map<String, dynamic>> subscriptions = [
    {
      'name': 'Fresh Milk',
      'category': 'Dairy',
      'price': 40,
      'unit': 'litre',
      'quantity': 1,
      'frequency': 'Daily',
      'nextDelivery': 'Tomorrow',
      'status': 'Active',
      'icon': Icons.local_drink_outlined,
    },
    {
      'name': 'Drinking Water',
      'category': 'Water',
      'price': 80,
      'unit': 'can',
      'quantity': 2,
      'frequency': 'Weekly',
      'nextDelivery': '20 Aug 2026',
      'status': 'Active',
      'icon': Icons.water_drop_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Subscriptions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: subscriptions.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subscriptions.length,
              itemBuilder: (context, index) {
                return _subscriptionCard(subscriptions[index], index);
              },
            ),
    );
  }

  Widget _subscriptionCard(Map<String, dynamic> subscription, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FB),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  subscription['icon'],
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
                      subscription['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subscription['category'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B778C),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '₹${subscription['price']} / ${subscription['unit']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),

              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F6F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subscription['status'],
                  style: const TextStyle(
                    color: Color(0xFF008F7A),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(height: 1),

          const SizedBox(height: 15),

          // Quantity & Frequency
          Row(
            children: [
              Expanded(
                child: _infoItem(
                  Icons.shopping_basket_outlined,
                  'Quantity',
                  '${subscription['quantity']} ${subscription['unit']}',
                ),
              ),

              Expanded(
                child: _infoItem(
                  Icons.repeat,
                  'Frequency',
                  subscription['frequency'],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Next Delivery
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  color: Color(0xFF1565C0),
                  size: 22,
                ),

                const SizedBox(width: 10),

                const Text(
                  'Next Delivery',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B778C)),
                ),

                const Spacer(),

                Text(
                  subscription['nextDelivery'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Manage Button
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton(
              onPressed: () {
                _showManageDialog(index);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1565C0),
                side: const BorderSide(color: Color(0xFF1565C0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Manage Subscription',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 21),

        const SizedBox(width: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Color(0xFF6B778C)),
            ),

            const SizedBox(height: 3),

            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF172B4D),
              ),
            ),
          ],
        ),
      ],
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
              Icons.subscriptions_outlined,
              size: 80,
              color: Color(0xFFB0BEC5),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Subscriptions Yet',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Subscribe to a service and it will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF6B778C)),
            ),
          ],
        ),
      ),
    );
  }

  void _showManageDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Manage Subscription'),
          content: const Text(
            'What would you like to do with this subscription?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  subscriptions[index]['status'] = 'Paused';
                });

                Navigator.pop(context);
              },
              child: const Text('Pause'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  subscriptions.removeAt(index);
                });

                Navigator.pop(context);
              },
              child: const Text('Cancel Subscription'),
            ),
          ],
        );
      },
    );
  }
}
