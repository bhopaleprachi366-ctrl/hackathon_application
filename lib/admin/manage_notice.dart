import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageNoticesPage extends StatefulWidget {
  const ManageNoticesPage({super.key});

  @override
  State<ManageNoticesPage> createState() => _ManageNoticesPageState();
}

class _ManageNoticesPageState extends State<ManageNoticesPage> {
  final CollectionReference noticesCollection = FirebaseFirestore.instance
      .collection('notices');

  // ---------------- ADD / EDIT NOTICE ----------------

  void showNoticeDialog({DocumentSnapshot? document}) {
    final bool isEditing = document != null;

    final titleController = TextEditingController(
      text: isEditing ? document['title'] : '',
    );

    final descriptionController = TextEditingController(
      text: isEditing ? document['description'] : '',
    );

    DateTime selectedDate = isEditing
        ? (document['date'] as Timestamp).toDate()
        : DateTime.now();

    bool isImportant = isEditing ? document['isImportant'] : false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Notice' : 'Add Notice'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Notice Title',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // DATE
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_month),
                      title: const Text('Notice Date'),
                      subtitle: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
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

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Important Notice'),
                      value: isImportant,
                      onChanged: (value) {
                        setDialogState(() {
                          isImportant = value;
                        });
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
                    if (titleController.text.trim().isEmpty ||
                        descriptionController.text.trim().isEmpty) {
                      return;
                    }

                    try {
                      if (isEditing) {
                        await noticesCollection.doc(document.id).update({
                          'title': titleController.text.trim(),
                          'description': descriptionController.text.trim(),
                          'date': Timestamp.fromDate(selectedDate),
                          'isImportant': isImportant,
                        });
                      } else {
                        await noticesCollection.add({
                          'title': titleController.text.trim(),
                          'description': descriptionController.text.trim(),
                          'date': Timestamp.fromDate(selectedDate),
                          'isImportant': isImportant,
                        });
                      }

                      if (mounted) {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing
                                  ? 'Notice updated successfully'
                                  : 'Notice added successfully',
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

  // ---------------- DELETE NOTICE ----------------

  void deleteNotice(DocumentSnapshot document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Notice'),
          content: const Text('Are you sure you want to delete this notice?'),
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
                  await noticesCollection.doc(document.id).delete();

                  if (mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notice deleted successfully'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unable to delete notice')),
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
      appBar: AppBar(title: const Text('Manage Notices')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoticeDialog();
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: noticesCollection.orderBy('date', descending: true).snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notices available'));
          }

          final notices = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final document = notices[index];

              final String title = document['title'];
              final String description = document['description'];
              final bool isImportant = document['isImportant'];

              final Timestamp timestamp = document['date'];
              final DateTime date = timestamp.toDate();

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
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          if (isImportant)
                            const Icon(Icons.star, color: Colors.orange),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(description, style: const TextStyle(fontSize: 14)),

                      const SizedBox(height: 10),

                      Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              showNoticeDialog(document: document);
                            },
                            icon: const Icon(Icons.edit),
                          ),

                          IconButton(
                            onPressed: () {
                              deleteNotice(document);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
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
