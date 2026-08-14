import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageTimetablePage extends StatefulWidget {
  const ManageTimetablePage({super.key});

  @override
  State<ManageTimetablePage> createState() => _ManageTimetablePageState();
}

class _ManageTimetablePageState extends State<ManageTimetablePage> {
  final CollectionReference timetableCollection = FirebaseFirestore.instance
      .collection('timetable');

  // ---------------- ADD / EDIT TIMETABLE ----------------

  void showTimetableDialog({DocumentSnapshot? document}) {
    final bool isEditing = document != null;

    final subjectController = TextEditingController(
      text: isEditing ? document['subject'] : '',
    );

    final roomController = TextEditingController(
      text: isEditing ? document['room'] : '',
    );

    final startTimeController = TextEditingController(
      text: isEditing ? document['startTime'] : '',
    );

    final endTimeController = TextEditingController(
      text: isEditing ? document['endTime'] : '',
    );

    String selectedDay = isEditing ? document['day'] : 'Monday';

    String selectedBranch = isEditing ? document['branch'] : 'Computer';

    String selectedSemester = isEditing ? document['semester'] : '5';

    final List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    final List<String> branches = [
      'Computer',
      'Elecrical',
      'Electronics',
      'Mechanical',
      'Civil',
    ];

    final List<String> semesters = ['1', '2', '3', '4', '5', '6'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Timetable' : 'Add Timetable'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SUBJECT
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // DAY
                    DropdownButtonFormField<String>(
                      value: selectedDay,
                      decoration: const InputDecoration(
                        labelText: 'Day',
                        border: OutlineInputBorder(),
                      ),
                      items: days.map((day) {
                        return DropdownMenuItem(value: day, child: Text(day));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedDay = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    // BRANCH
                    DropdownButtonFormField<String>(
                      value: selectedBranch,
                      decoration: const InputDecoration(
                        labelText: 'Branch',
                        border: OutlineInputBorder(),
                      ),
                      items: branches.map((branch) {
                        return DropdownMenuItem(
                          value: branch,
                          child: Text(branch),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedBranch = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    // SEMESTER
                    DropdownButtonFormField<String>(
                      value: selectedSemester,
                      decoration: const InputDecoration(
                        labelText: 'Semester',
                        border: OutlineInputBorder(),
                      ),
                      items: semesters.map((semester) {
                        return DropdownMenuItem(
                          value: semester,
                          child: Text(semester),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedSemester = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    // START TIME
                    TextField(
                      controller: startTimeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Start Time',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          startTimeController.text = pickedTime.format(context);
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    // END TIME
                    TextField(
                      controller: endTimeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'End Time',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          endTimeController.text = pickedTime.format(context);
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    // ROOM
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(
                        labelText: 'Room',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (subjectController.text.trim().isEmpty ||
                        startTimeController.text.trim().isEmpty ||
                        endTimeController.text.trim().isEmpty ||
                        roomController.text.trim().isEmpty) {
                      return;
                    }

                    try {
                      final data = {
                        'subject': subjectController.text.trim(),
                        'day': selectedDay,
                        'branch': selectedBranch,
                        'semester': selectedSemester,
                        'startTime': startTimeController.text.trim(),
                        'endTime': endTimeController.text.trim(),
                        'room': roomController.text.trim(),
                      };

                      if (isEditing) {
                        await timetableCollection.doc(document.id).update(data);
                      } else {
                        await timetableCollection.add(data);
                      }

                      if (mounted) {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing
                                  ? 'Timetable updated successfully'
                                  : 'Timetable added successfully',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Something went wrong')),
                        );
                      }
                    }
                  },
                  child: Text(isEditing ? 'Update' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------------- DELETE ----------------

  void deleteTimetable(DocumentSnapshot document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Timetable'),

          content: const Text(
            'Are you sure you want to delete this timetable entry?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                try {
                  await timetableCollection.doc(document.id).delete();

                  if (mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Timetable deleted successfully'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to delete timetable'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Timetable')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTimetableDialog();
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: timetableCollection.orderBy('day').snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No timetable available'));
          }

          final timetable = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: timetable.length,
            itemBuilder: (context, index) {
              final document = timetable[index];

              final String subject = document['subject'];

              final String day = document['day'];

              final String branch = document['branch'];

              final String semester = document['semester'];

              final String startTime = document['startTime'];

              final String endTime = document['endTime'];

              final String room = document['room'];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subject,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              showTimetableDialog(document: document);
                            },
                            icon: const Icon(Icons.edit),
                          ),

                          IconButton(
                            onPressed: () {
                              deleteTimetable(document);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '$day • $startTime - $endTime',
                        style: const TextStyle(fontSize: 15),
                      ),

                      const SizedBox(height: 6),

                      Text('Room: $room'),

                      const SizedBox(height: 6),

                      Text(
                        'Branch: $branch • Semester: $semester',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
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
