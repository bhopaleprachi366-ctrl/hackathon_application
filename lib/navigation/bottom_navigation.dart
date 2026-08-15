import 'package:flutter/material.dart';
import 'package:project/admin/admin_profile.dart';
import 'package:project/admin/dashboard.dart';
import 'package:project/admin/manage_notice.dart';
import 'package:project/admin/manage_student.dart';
import 'package:project/admin/manage_timetable.dart';
import 'package:project/theme/app_theme.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    AdminDashboard(),
    ManageNoticesPage(),
    ManageTimetablePage(),
    ManageStudentsPage(),
    AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.primaryColor,
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),

          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Notices',
          ),

          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Timetable',
          ),

          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Students',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
