import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageStudentsPage extends StatefulWidget {
  const ManageStudentsPage({super.key});

  @override
  State<ManageStudentsPage> createState() => _ManageStudentsPageState();
}

class _ManageStudentsPageState extends State<ManageStudentsPage> {
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');

  final TextEditingController searchController = TextEditingController();

  String searchText = '';
  String selectedBranch = 'All';
  String selectedSemester = 'All';

  final List<String> branches = [
    'All',
    'Computer',
    'IT',
    'ENTC',
    'Mechanical',
    'Civil',
  ];

  final List<String> semesters = ['All', '1', '2', '3', '4', '5', '6'];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Students')),

      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.where('role', isEqualTo: 'student').snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No students found'));
          }

          final allStudents = snapshot.data!.docs;

          // Filter students
          final filteredStudents = allStudents.where((document) {
            final String name = (document['name'] ?? '')
                .toString()
                .toLowerCase();

            final String email = (document['email'] ?? '')
                .toString()
                .toLowerCase();

            final String rollNo = (document['rollNo'] ?? '')
                .toString()
                .toLowerCase();

            final String branch = (document['branch'] ?? '').toString();

            final String semester = (document['semester'] ?? '').toString();

            final String search = searchText.toLowerCase().trim();

            final bool matchesSearch =
                name.contains(search) ||
                email.contains(search) ||
                rollNo.contains(search);

            final bool matchesBranch =
                selectedBranch == 'All' || branch == selectedBranch;

            final bool matchesSemester =
                selectedSemester == 'All' || semester == selectedSemester;

            return matchesSearch && matchesBranch && matchesSemester;
          }).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name, email or roll no.',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchText.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();

                              setState(() {
                                searchText = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // Filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Branch Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
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
                            setState(() {
                              selectedBranch = value;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Semester Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
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
                            setState(() {
                              selectedSemester = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Student count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${filteredStudents.length} student(s) found',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // Student List
              Expanded(
                child: filteredStudents.isEmpty
                    ? const Center(child: Text('No students found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, index) {
                          final document = filteredStudents[index];

                          final String name = document['name'] ?? '';

                          final String email = document['email'] ?? '';

                          final String image = document['image'] ?? '';

                          final String rollNo = document['rollNo'] ?? '';

                          final String branch = document['branch'] ?? '';

                          final String semester = document['semester'] ?? '';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Student image
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: image.isNotEmpty
                                            ? NetworkImage(image)
                                            : null,
                                        child: image.isEmpty
                                            ? const Icon(Icons.person, size: 30)
                                            : null,
                                      ),

                                      const SizedBox(width: 15),

                                      // Name and Email
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name.isEmpty ? 'No Name' : name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(height: 5),

                                            Text(
                                              email,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Divider(height: 25),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: _studentInfo(
                                          Icons.badge,
                                          'Roll No',
                                          rollNo,
                                        ),
                                      ),
                                      Expanded(
                                        child: _studentInfo(
                                          Icons.school,
                                          'Branch',
                                          branch,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 15),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: _studentInfo(
                                          Icons.menu_book,
                                          'Semester',
                                          semester,
                                        ),
                                      ),
                                      Expanded(
                                        child: _studentInfo(
                                          Icons.person,
                                          'Role',
                                          'Student',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _studentInfo(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 2),

              Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
