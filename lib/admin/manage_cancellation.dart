import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageCancellationsPage extends StatefulWidget {
  const ManageCancellationsPage({super.key});

  @override
  State<ManageCancellationsPage> createState() =>
      _ManageCancellationsPageState();
}

class _ManageCancellationsPageState extends State<ManageCancellationsPage> {
  final CollectionReference cancellationsCollection = FirebaseFirestore.instance
      .collection('lectureCancellations');

  // Add / Edit Cancellation
  void showCancellationDialog({DocumentSnapshot? document}) {
    final bool isEditing = document != null;

    final subjectController = TextEditingController(
      text: isEditing ? document['subject'] : '',
    );

    final startTimeController = TextEditingController(
      text: isEditing ? document['startTime'] : '',
    );

    final endTimeController = TextEditingController(
      text: isEditing ? document['endTime'] : '',
    );

    DateTime selectedDate = isEditing
        ? (document['date'] as Timestamp).toDate()
        : DateTime.now();

    String selectedBranch = isEditing ? document['branch'] : 'Computer';

    String selectedSemester = isEditing ? document['semester'] : '5';

    final List<String> branches = [
      'Computer',
      'IT',
      'ENTC',
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
              title: Text(isEditing ? 'Edit Cancellation' : 'Add Cancellation'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Subject
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Date
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_month),
                      title: const Text('Date'),
                      subtitle: Text(
                        '${selectedDate.day}/'
                        '${selectedDate.month}/'
                        '${selectedDate.year}',
                      ),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setDialogState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    // Branch
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

                    // Semester
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

                    // Start Time
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

                    // End Time
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
                        endTimeController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields'),
                        ),
                      );
                      return;
                    }

                    try {
                      final data = {
                        'subject': subjectController.text.trim(),
                        'date': Timestamp.fromDate(selectedDate),
                        'branch': selectedBranch,
                        'semester': selectedSemester,
                        'startTime': startTimeController.text.trim(),
                        'endTime': endTimeController.text.trim(),
                      };

                      if (isEditing) {
                        await cancellationsCollection
                            .doc(document.id)
                            .update(data);
                      } else {
                        await cancellationsCollection.add(data);
                      }

                      if (mounted) {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing
                                  ? 'Cancellation updated successfully'
                                  : 'Cancellation added successfully',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Something went wrong: $e')),
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

  // Delete Cancellation
  void deleteCancellation(DocumentSnapshot document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Cancellation'),
          content: const Text(
            'Are you sure you want to delete this cancellation?',
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
                  await cancellationsCollection.doc(document.id).delete();

                  if (mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cancellation deleted successfully'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to delete cancellation'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecture Cancellations')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCancellationDialog();
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: cancellationsCollection
            .orderBy('date', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No lecture cancellations'));
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

              final DateTime date = (document['date'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded),

                          const SizedBox(width: 10),

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
                              showCancellationDialog(document: document);
                            },
                            icon: const Icon(Icons.edit),
                          ),

                          IconButton(
                            onPressed: () {
                              deleteCancellation(document);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text('${date.day}/${date.month}/${date.year}'),

                      const SizedBox(height: 5),

                      Text('$startTime - $endTime'),

                      const SizedBox(height: 5),

                      Text(
                        '$branch • Semester $semester',
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
