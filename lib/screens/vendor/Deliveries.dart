import 'package:flutter/material.dart';

class DeliveriesPage extends StatelessWidget {
  const DeliveriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Deliveries',
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
              'Upcoming Deliveries',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Manage your upcoming service deliveries.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // Delivery Summary
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.local_shipping_outlined,
                    value: '24',
                    title: 'Total',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.pending_actions_outlined,
                    value: '06',
                    title: 'Pending',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Delivery List
            Expanded(
              child: ListView(
                children: [
                  _buildDeliveryCard(
                    context,
                    customerName: 'Rahul Patil',
                    service: 'Home Cleaning',
                    date: '15 Aug 2026',
                    time: '10:00 AM',
                    status: 'Pending',
                  ),

                  const SizedBox(height: 12),

                  _buildDeliveryCard(
                    context,
                    customerName: 'Priya Sharma',
                    service: 'Laundry Service',
                    date: '15 Aug 2026',
                    time: '12:30 PM',
                    status: 'Confirmed',
                  ),

                  const SizedBox(height: 12),

                  _buildDeliveryCard(
                    context,
                    customerName: 'Amit Joshi',
                    service: 'Car Washing',
                    date: '16 Aug 2026',
                    time: '09:00 AM',
                    status: 'Pending',
                  ),

                  const SizedBox(height: 12),

                  _buildDeliveryCard(
                    context,
                    customerName: 'Sneha Deshmukh',
                    service: 'Home Cleaning',
                    date: '16 Aug 2026',
                    time: '02:00 PM',
                    status: 'Confirmed',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String value,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            size: 28,
            color: Color(0xFF2563EB),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(
    BuildContext context, {
    required String customerName,
    required String service,
    required String date,
    required String time,
    required String status,
  }) {
    final bool isConfirmed = status == 'Confirmed';

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
          // Delivery Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFF2563EB),
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          // Delivery Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  service,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isConfirmed
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isConfirmed
                          ? const Color(0xFF2563EB)
                          : Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // More Options
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            onSelected: (value) {
              if (value == 'complete') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Delivery marked as completed'),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF2563EB),
                    ),
                    SizedBox(width: 10),
                    Text('Mark Completed'),
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