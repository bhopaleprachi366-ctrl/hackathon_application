import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import '../theme/app_theme.dart';

class LectureCancellations extends StatelessWidget {
  const LectureCancellations({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference cancellationsCollection =
        FirebaseFirestore.instance.collection('lectureCancellations');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lecture Cancellations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: cancellationsCollection
            .orderBy('date', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No lecture cancellations',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final cancellations = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cancellations.length,
            itemBuilder: (context, index) {
              final document = cancellations[index];

              final String subject = document['subject'];
              final String branch = document['branch'];
              final String semester = document['semester'];
              final String startTime = document['startTime'];
              final String endTime = document['endTime'];

              final DateTime date =
                  (document['date'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.red.shade100,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                subject,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // CANCELLED LABEL
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'LECTURE CANCELLED',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // DATE
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${date.day}/${date.month}/${date.year}',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // TIME
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$startTime - $endTime',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // BRANCH + SEMESTER
                        Row(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$branch • Semester $semester',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}