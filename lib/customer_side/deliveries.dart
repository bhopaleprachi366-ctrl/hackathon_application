import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveriesPage extends StatefulWidget {
  const DeliveriesPage({super.key});

  @override
  State<DeliveriesPage> createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> {
  String selectedFilter = 'All';

  final List<String> filters = ['All', 'Upcoming', 'Delivered'];

  // ==========================================================
  // GET DELIVERIES FROM FIRESTORE
  // ==========================================================

  Stream<List<Map<String, dynamic>>> getDeliveries() {
    return FirebaseFirestore.instance
        .collection('deliveries')
        .orderBy('deliveryDate')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return {
              'id': doc.id,
              'createdAt': data['createdAt'],
              'deliveryDate': data['deliveryDate'],
              'quantity': data['quantity'] ?? 1,
              'serviceId': data['serviceId'] ?? '',
              'serviceName': data['serviceName'] ?? 'Service',
              'category': data['category'] ?? 'Service',
              'unit': data['unit'] ?? '',
              'status': data['status'] ?? 'scheduled',
              'subscriptionId': data['subscriptionId'] ?? '',
              'userId': data['userId'] ?? '',
              'vendorId': data['vendorId'] ?? '',
            };
          }).toList();
        });
  }

  // ==========================================================
  // CONVERT FIRESTORE TIMESTAMP TO DATETIME
  // ==========================================================

  DateTime? _getDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }

  // ==========================================================
  // FORMAT DATE
  // ==========================================================

  String _formatDate(dynamic value) {
    final date = _getDateTime(value);

    if (date == null) {
      return 'Not scheduled';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ==========================================================
  // FORMAT TIME
  // ==========================================================

  String _formatTime(dynamic value) {
    final date = _getDateTime(value);

    if (date == null) {
      return 'Not available';
    }

    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:$minute $period';
  }

  // ==========================================================
  // STATUS
  // ==========================================================

  String _displayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'Upcoming';

      case 'upcoming':
        return 'Upcoming';

      case 'delivered':
        return 'Delivered';

      case 'cancelled':
        return 'Cancelled';

      case 'pending':
        return 'Pending';

      default:
        return status;
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
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
          'Deliveries',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ======================================================
      // FIRESTORE STREAM
      // ======================================================
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getDeliveries(),
        builder: (context, snapshot) {
          // --------------------------------------------------
          // LOADING
          // --------------------------------------------------

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            );
          }

          // --------------------------------------------------
          // ERROR
          // --------------------------------------------------

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

          final deliveries = snapshot.data ?? [];

          // --------------------------------------------------
          // FILTER
          // --------------------------------------------------

          final filteredDeliveries = deliveries.where((delivery) {
            final status = _displayStatus(delivery['status'].toString());

            if (selectedFilter == 'All') {
              return true;
            }

            return status == selectedFilter;
          }).toList();

          return Column(
            children: [
              // =================================================
              // FILTER BUTTONS
              // =================================================
              SizedBox(
                height: 65,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];

                    final bool isSelected = selectedFilter == filter;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
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
                            filter,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF172B4D),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // =================================================
              // DELIVERY COUNT
              // =================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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

              // =================================================
              // DELIVERY LIST
              // =================================================
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
          );
        },
      ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

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
                Icons.local_shipping_outlined,
                size: 45,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No deliveries found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your upcoming deliveries will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF6B778C)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DELIVERY CARD
  // ==========================================================

  Widget _deliveryCard(Map<String, dynamic> delivery) {
    final String status = _displayStatus(delivery['status'].toString());

    final bool isDelivered = status == 'Delivered';
    final bool isCancelled = status == 'Cancelled';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
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
          // ====================================================
          // HEADER
          // ====================================================
          Row(
            children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FB),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: Color(0xFF1565C0),
                  size: 32,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery['serviceName'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      delivery['category'].toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B778C),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Quantity: ${delivery['quantity']} ${delivery['unit']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF172B4D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(status),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(height: 1),

          const SizedBox(height: 15),

          // ====================================================
          // DATE + TIME
          // ====================================================
          Row(
            children: [
              Expanded(
                child: _infoItem(
                  Icons.calendar_today_outlined,
                  'Delivery Date',
                  _formatDate(delivery['deliveryDate']),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _infoItem(
                  Icons.access_time_outlined,
                  'Delivery Time',
                  _formatTime(delivery['deliveryDate']),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ====================================================
          // SUBSCRIPTION
          // ====================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.subscriptions_outlined,
                  color: Color(0xFF1565C0),
                  size: 20,
                ),

                const SizedBox(width: 10),

                const Text(
                  'Subscription',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B778C)),
                ),

                const Spacer(),

                Flexible(
                  child: Text(
                    delivery['subscriptionId'].toString().isEmpty
                        ? 'Not assigned'
                        : delivery['subscriptionId'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF172B4D),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // ====================================================
          // ACTION
          // ====================================================
          if (!isDelivered && !isCancelled)
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showDeliveryDetails(delivery);
                },
                icon: const Icon(Icons.location_on_outlined, size: 20),
                label: const Text(
                  'View Delivery',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
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
          else if (isDelivered)
            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Delivery Completed',
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

  // ==========================================================
  // STATUS BADGE
  // ==========================================================

  Widget _statusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Delivered':
        backgroundColor = const Color(0xFFE8F6F3);
        textColor = const Color(0xFF008F7A);
        break;

      case 'Cancelled':
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = Colors.red;
        break;

      case 'Pending':
        backgroundColor = const Color(0xFFFFF4E5);
        textColor = const Color(0xFFE08A00);
        break;

      default:
        backgroundColor = const Color(0xFFE8F1FB);
        textColor = const Color(0xFF1565C0);
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

  // ==========================================================
  // INFO ITEM
  // ==========================================================

  Widget _infoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 20),

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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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

  // ==========================================================
  // DELIVERY DETAILS
  // ==========================================================

  void _showDeliveryDetails(Map<String, dynamic> delivery) {
    final String status = _displayStatus(delivery['status'].toString());

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delivery Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dialogRow('Service', delivery['serviceName'].toString()),

              const SizedBox(height: 12),

              _dialogRow('Status', status),

              const SizedBox(height: 12),

              _dialogRow('Date', _formatDate(delivery['deliveryDate'])),

              const SizedBox(height: 12),

              _dialogRow('Time', _formatTime(delivery['deliveryDate'])),

              const SizedBox(height: 12),

              _dialogRow(
                'Quantity',
                '${delivery['quantity']} ${delivery['unit']}',
              ),

              const SizedBox(height: 12),

              _dialogRow(
                'Service ID',
                delivery['serviceId'].toString().isEmpty
                    ? 'Not assigned'
                    : delivery['serviceId'].toString(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFF1565C0)),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // DIALOG ROW
  // ==========================================================

  Widget _dialogRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B778C)),
          ),
        ),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172B4D),
            ),
          ),
        ),
      ],
    );
  }
}
