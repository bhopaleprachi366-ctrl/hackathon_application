import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SmartCampusApp());
}

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Campus Companion',

      // App theme
      theme: AppTheme.lightTheme,

      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Campus Companion')),
      body: const Center(
        child: Text(
          'Welcome to Smart Campus Companion',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
