import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MySubscriptionsPage extends StatefulWidget {
  const MySubscriptionsPage({super.key});

  @override
  State<MySubscriptionsPage> createState() => _MySubscriptionsPageState();
}

class _MySubscriptionsPageState extends State<MySubscriptionsPage> {
  // ----------------------------------------------------------
  // GET SUBSCRIPTIONS FROM FIRESTORE
  // ----------------------------------------------------------
  Stream<List<Map<String, dynamic>>> getSubscriptions() {
    return FirebaseFirestore.instance
        .collection('subscriptions')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return {
              'id': doc.id,
              'name': data['serviceName'] ?? 'Service',
              'category': data['category'] ?? 'Category',
              'price': data['price'] ?? 0,
              'unit': data['unit'] ?? '',
              'quantity': data['quantity'] ?? 1,
              'frequency': data['frequency'] ?? 'Daily',
              'status': data['status'] ?? 'Active',
              'nextDelivery': data['nextDelivery'] ?? 'Not scheduled',
              'address': data['address'] ?? '',
              'icon': _getServiceIcon(data['category']),
            };
          }).toList();
        });
  }

  // ----------------------------------------------------------
  // SERVICE ICON
  // ----------------------------------------------------------
  IconData _getServiceIcon(dynamic category) {
    switch (category?.toString()) {
      case 'Dairy':
        return Icons.local_drink_outlined;

      case 'Water':
        return Icons.water_drop_outlined;

      case 'Food':
        return Icons.restaurant_outlined;

      case 'Newspaper':
        return Icons.menu_book_outlined;

      case 'Vegetables':
        return Icons.eco_outlined;

      default:
        return Icons.miscellaneous_services_outlined;
    }
  }

  // ----------------------------------------------------------
  // UPDATE STATUS
  // ----------------------------------------------------------
  Future<void> updateSubscriptionStatus(
    String documentId,
    String newStatus,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('subscriptions')
          .doc(documentId)
          .update({
            'status': newStatus,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == 'Paused'
                ? 'Subscription paused'
                : 'Subscription resumed',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating subscription: $e')),
      );
    }
  }

  // ----------------------------------------------------------
  // CANCEL SUBSCRIPTION
  // ----------------------------------------------------------
  Future<void> cancelSubscription(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('subscriptions')
          .doc(documentId)
          .update({
            'status': 'Cancelled',
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Subscription cancelled')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling subscription: $e')),
      );
    }
  }

  // ----------------------------------------------------------
  // CANCEL CONFIRMATION
  // ----------------------------------------------------------
  void showCancelDialog(String documentId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cancel Subscription'),
          content: const Text(
            'Are you sure you want to cancel this subscription?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await cancelSubscription(documentId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),

      // ------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Subscriptions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ------------------------------------------------------
      // FIRESTORE STREAM
      // ------------------------------------------------------
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getSubscriptions(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 55,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF6B778C),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final subscriptions = snapshot.data ?? [];

          // Empty
          if (subscriptions.isEmpty) {
            return _emptyState();
          }

          // List
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 25),
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              return _subscriptionCard(subscriptions[index]);
            },
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // EMPTY STATE
  // ----------------------------------------------------------
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FB),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.subscriptions_outlined,
                size: 45,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No subscriptions yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your active subscriptions will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF6B778C)),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // SUBSCRIPTION CARD
  // ----------------------------------------------------------
  Widget _subscriptionCard(Map<String, dynamic> subscription) {
    final String documentId = subscription['id']?.toString() ?? '';

    final String status = subscription['status']?.toString() ?? 'Active';

    final bool isCancelled = status == 'Cancelled';

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
          // --------------------------------------------------
          // HEADER
          // --------------------------------------------------
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
                  subscription['icon'] as IconData,
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
                      subscription['name'].toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subscription['category'].toString(),
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

              _statusBadge(status),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(height: 1),

          const SizedBox(height: 15),

          // --------------------------------------------------
          // QUANTITY + FREQUENCY
          // --------------------------------------------------
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
                  subscription['frequency'].toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // --------------------------------------------------
          // NEXT DELIVERY
          // --------------------------------------------------
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
                  size: 20,
                ),

                const SizedBox(width: 10),

                const Text(
                  'Next Delivery',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B778C)),
                ),

                const Spacer(),

                Flexible(
                  child: Text(
                    subscription['nextDelivery'].toString(),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF172B4D),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // --------------------------------------------------
          // MANAGE BUTTON
          // --------------------------------------------------
          if (!isCancelled)
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                onPressed: () {
                  _showManageBottomSheet(subscription);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1565C0),
                  side: const BorderSide(color: Color(0xFF1565C0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Manage Subscription'),
              ),
            ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // STATUS BADGE
  // ----------------------------------------------------------
  Widget _statusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    if (status == 'Paused') {
      backgroundColor = const Color(0xFFFFF4E5);
      textColor = const Color(0xFFE08A00);
    } else if (status == 'Cancelled') {
      backgroundColor = const Color(0xFFFFEBEE);
      textColor = Colors.red;
    } else {
      backgroundColor = const Color(0xFFE8F6F3);
      textColor = const Color(0xFF008F7A);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // INFO ITEM
  // ----------------------------------------------------------
  Widget _infoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 21),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
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
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // MANAGE BOTTOM SHEET
  // ----------------------------------------------------------
  void _showManageBottomSheet(Map<String, dynamic> subscription) {
    final String documentId = subscription['id']?.toString() ?? '';

    final String status = subscription['status']?.toString() ?? 'Active';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage Subscription',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 20),

                // PAUSE / RESUME
                ListTile(
                  leading: Icon(
                    status == 'Paused' ? Icons.play_arrow : Icons.pause,
                    color: const Color(0xFF1565C0),
                  ),
                  title: Text(
                    status == 'Paused'
                        ? 'Resume Subscription'
                        : 'Pause Subscription',
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);

                    await updateSubscriptionStatus(
                      documentId,
                      status == 'Paused' ? 'Active' : 'Paused',
                    );
                  },
                ),

                // CANCEL
                ListTile(
                  leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                  title: const Text(
                    'Cancel Subscription',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);

                    showCancelDialog(documentId);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
