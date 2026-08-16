import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorDashboard extends StatelessWidget {
  const VendorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
          'Vendor Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service')
            .where('vendorId', isEqualTo: user.uid)
            .snapshots(),

        builder: (context, serviceSnapshot) {
          if (serviceSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (serviceSnapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${serviceSnapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final int serviceCount =
              serviceSnapshot.data?.docs.length ?? 0;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('subscriptions')
                .where('vendorId', isEqualTo: user.uid)
                .snapshots(),

            builder: (context, subscriptionSnapshot) {
              if (subscriptionSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final int subscriberCount =
                  subscriptionSnapshot.data?.docs.length ?? 0;

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('deliveries')
                    .where('vendorId', isEqualTo: user.uid)
                    .snapshots(),

                builder: (context, deliverySnapshot) {
                  if (deliverySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (deliverySnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${deliverySnapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final deliveries =
                      deliverySnapshot.data?.docs ?? [];

                  final int deliveryCount = deliveries.length;

                  final int pendingCount =
                      deliveries.where((doc) {
                    final data =
                        doc.data() as Map<String, dynamic>;

                    final status =
                        data['status']?.toString().toLowerCase();

                    return status == 'pending' ||
                        status == 'scheduled';
                  }).length;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Welcome, Vendor 👋',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Manage your services and deliveries easily.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Statistics
                        Row(
                          children: [

                            Expanded(
                              child: _buildStatCard(
                                icon: Icons
                                    .miscellaneous_services_outlined,
                                title: 'Services',
                                value: '$serviceCount',
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.people_outline,
                                title: 'Subscribers',
                                value: '$subscriberCount',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [

                            Expanded(
                              child: _buildStatCard(
                                icon: Icons
                                    .local_shipping_outlined,
                                title: 'Deliveries',
                                value: '$deliveryCount',
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _buildStatCard(
                                icon: Icons
                                    .pending_actions_outlined,
                                title: 'Pending',
                                value: '$pendingCount',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        _buildActionCard(
                          context,
                          icon: Icons
                              .miscellaneous_services_outlined,
                          title: 'My Services',
                          subtitle:
                              'View and manage your services',
                          onTap: () {
                            // Add navigation here
                          },
                        ),

                        const SizedBox(height: 12),

                        _buildActionCard(
                          context,
                          icon: Icons.add_circle_outline,
                          title: 'Add Service',
                          subtitle:
                              'Create a new service',
                          onTap: () {
                            // Add navigation here
                          },
                        ),

                        const SizedBox(height: 12),

                        _buildActionCard(
                          context,
                          icon: Icons.people_outline,
                          title: 'Subscribers',
                          subtitle:
                              'View your active subscribers',
                          onTap: () {
                            // Add navigation here
                          },
                        ),

                        const SizedBox(height: 12),

                        _buildActionCard(
                          context,
                          icon: Icons
                              .local_shipping_outlined,
                          title: 'Deliveries',
                          subtitle:
                              'Manage upcoming deliveries',
                          onTap: () {
                            // Add navigation here
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            size: 28,
            color: const Color(0xFF4F46E5),
          ),

          const SizedBox(height: 12),

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
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
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
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color: const Color(0xFF4F46E5),
                size: 26,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}