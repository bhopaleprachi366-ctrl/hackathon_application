import 'package:flutter/material.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  final List<Map<String, String>> subscriptions = const [
    {
      'user': 'Rahul Patil',
      'service': 'Home Cleaning',
      'vendor': 'Raj Services',
      'price': '₹499',
      'status': 'Active',
    },
    {
      'user': 'Priya Sharma',
      'service': 'Laundry Service',
      'vendor': 'Fresh Laundry',
      'price': '₹299',
      'status': 'Active',
    },
    {
      'user': 'Amit Joshi',
      'service': 'Car Washing',
      'vendor': 'Quick Clean',
      'price': '₹399',
      'status': 'Cancelled',
    },
    {
      'user': 'Sneha More',
      'service': 'Home Cleaning',
      'vendor': 'Home Care',
      'price': '₹499',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Subscriptions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Subscriptions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'View and manage customer subscriptions.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.separated(
                itemCount: subscriptions.length,

                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },

                itemBuilder: (context, index) {
                  final subscription = subscriptions[index];

                  return _buildSubscriptionCard(
                    user: subscription['user']!,
                    service: subscription['service']!,
                    vendor: subscription['vendor']!,
                    price: subscription['price']!,
                    status: subscription['status']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required String user,
    required String service,
    required String vendor,
    required String price,
    required String status,
  }) {
    final bool isActive = status == 'Active';

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(26),
            ),

            child: const Icon(
              Icons.subscriptions_outlined,
              color: Color(0xFF2563EB),
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  service,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Vendor: $vendor',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'view') {
                // View subscription
              } else if (value == 'cancel') {
                // Cancel subscription
              }
            },

            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: Color(0xFF2563EB),
                    ),
                    SizedBox(width: 10),
                    Text('View'),
                  ],
                ),
              ),

              PopupMenuItem(
                value: 'cancel',
                child: Row(
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text('Cancel'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}