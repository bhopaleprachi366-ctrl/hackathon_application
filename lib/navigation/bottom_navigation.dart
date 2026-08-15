import 'package:flutter/material.dart';

import 'package:hackathon_application/customer_side/homepage.dart';
import 'package:hackathon_application/customer_side/my_subscriptions.dart';
import 'package:hackathon_application/customer_side/services.dart';
import 'package:hackathon_application/customer_side/profile_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    ServicesPage(),
    MySubscriptionsPage(),
    Center(
      child: Text('Deliveries'),
    ),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: const Color(0xFF8A94A6),

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Services',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.autorenew),
            label: 'Subscriptions',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'Deliveries',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}