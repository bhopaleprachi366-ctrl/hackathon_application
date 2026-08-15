import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StudentTimetable extends StatefulWidget {
  const StudentTimetable({super.key});

  @override
  State<StudentTimetable> createState() => _StudentTimetableState();
}

class _StudentTimetableState extends State<StudentTimetable> {
  String selectedDay = 'Monday';

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Timetable',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // DAY SELECTOR
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final bool isSelected = selectedDay == day;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(day),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // TIMETABLE
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('timetable')
                  .where('day', isEqualTo: selectedDay)
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No lectures on $selectedDay',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                final lectures = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lectures.length,
                  itemBuilder: (context, index) {
                    final document = lectures[index];

                    final String subject = document['subject'];
                    final String day = document['day'];
                    final String branch = document['branch'];
                    final String semester = document['semester'];
                    final String startTime = document['startTime'];
                    final String endTime = document['endTime'];
                    final String room = document['room'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.menu_book_outlined,
                                color: AppTheme.primaryColor,
                                size: 28,
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 17,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          '$startTime - $endTime',
                                          style: TextStyle(
                                            color:
                                                Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.room_outlined,
                                        size: 17,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Room: $room',
                                        style: TextStyle(
                                          color:
                                              Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    '$day • $branch • Semester $semester',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}