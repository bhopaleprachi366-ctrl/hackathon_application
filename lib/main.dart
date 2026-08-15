import 'package:flutter/material.dart';
import 'package:hackathon_application/customer_side/homepage.dart';
import 'package:hackathon_application/navigation/bottom_navigation.dart';

void main() {
  runApp(const SubServeApp());
}

class SubServeApp extends StatelessWidget {
  const SubServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SubServe',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      ),
      home: NavigationPage(),
    );
  }
}
