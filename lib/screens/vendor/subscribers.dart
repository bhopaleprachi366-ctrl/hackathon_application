import 'package:flutter/material.dart';

class SubscribersPage extends StatelessWidget {
  const SubscribersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Subscribers',
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
              'Active Subscribers',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'View and manage your active subscribers.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // Total Subscribers Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    color: Colors.white,
                    size: 32,
                  ),

                  SizedBox(width: 15),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '48',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Subscribers',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Subscriber List
            Expanded(
              child: ListView(
                children: [

                  _buildSubscriberCard(
                    context,
                    name: 'Rahul Patil',
                    service: 'Home Cleaning',
                    date: 'Started: 10 Aug 2026',
                    status: 'Active',
                  ),

                  const SizedBox(height: 12),

                  _buildSubscriberCard(
                    context,
                    name: 'Priya Sharma',
                    service: 'Laundry Service',
                    date: 'Started: 08 Aug 2026',
                    status: 'Active',
                  ),

                  const SizedBox(height: 12),

                  _buildSubscriberCard(
                    context,
                    name: 'Amit Joshi',
                    service: 'Car Washing',
                    date: 'Started: 05 Aug 2026',
                    status: 'Active',
                  ),

                  const SizedBox(height: 12),

                  _buildSubscriberCard(
                    context,
                    name: 'Sneha Deshmukh',
                    service: 'Home Cleaning',
                    date: 'Started: 02 Aug 2026',
                    status: 'Active',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriberCard(
    BuildContext context, {
    required String name,
    required String service,
    required String date,
    required String status,
  }) {
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

          // Profile Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF2563EB),
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          // Subscriber Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  name,
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

                const SizedBox(height: 4),

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 7),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // More Button
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            onSelected: (value) {
              if (value == 'view') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Viewing $name'),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: Color(0xFF2563EB),
                    ),
                    SizedBox(width: 10),
                    Text('View Details'),
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