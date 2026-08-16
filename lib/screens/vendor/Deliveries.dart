import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveriesPage extends StatelessWidget {
  const DeliveriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login first'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Deliveries',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('deliveries')
            .where('vendorId', isEqualTo: user.uid)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final deliveries = snapshot.data?.docs ?? [];

          final int total = deliveries.length;

          final int pending = deliveries.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['status'] == 'scheduled' ||
                data['status'] == 'pending' ||
                data['status'] == 'Pending';
          }).length;

          return Padding(
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

                // Summary
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.local_shipping_outlined,
                        value: '$total',
                        title: 'Total',
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.pending_actions_outlined,
                        value: '$pending',
                        title: 'Pending',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: deliveries.isEmpty
                      ? const Center(
                          child: Text(
                            'No deliveries found.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: deliveries.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),

                          itemBuilder: (context, index) {
                            final doc = deliveries[index];

                            final data =
                                doc.data() as Map<String, dynamic>;

                            return _buildDeliveryCard(
                              context,
                              documentId: doc.id,
                              data: data,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            size: 28,
            color: const Color(0xFF2563EB),
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
    required String documentId,
    required Map<String, dynamic> data,
  }) {
    final String status =
        data['status']?.toString() ?? 'Unknown';

    final String userId =
        data['userId']?.toString() ?? 'Unknown';

    final String serviceId =
        data['serviceId']?.toString() ?? 'Unknown';

    final String quantity =
        data['quantity']?.toString() ?? '0';

    String deliveryDate = 'Date not available';

    if (data['deliveryDate'] is Timestamp) {
      final Timestamp timestamp = data['deliveryDate'];

      final DateTime date = timestamp.toDate();

      deliveryDate =
          '${date.day}/${date.month}/${date.year}';
    }

    final bool isCompleted =
        status.toLowerCase() == 'completed';

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [

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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Service ID: $serviceId',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Customer ID: $userId',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 5),

                Text(
                  'Quantity: $quantity',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2563EB),
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      deliveryDate,
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
                    color: isCompleted
                        ? Colors.green.shade50
                        : const Color(0xFFFFF7ED),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    status,
                    style: TextStyle(
                      color: isCompleted
                          ? Colors.green
                          : Colors.orange,

                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),

            onSelected: (value) async {
              if (value == 'complete') {
                await _markCompleted(
                  context,
                  documentId,
                );
              }
            },

            itemBuilder: (context) => [

              if (!isCompleted)
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

  Future<void> _markCompleted(
    BuildContext context,
    String documentId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('deliveries')
          .doc(documentId)
          .update({
        'status': 'completed',
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Delivery marked as completed',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}