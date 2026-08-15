import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/admin/admin_login.dart';
import 'package:project/admin/dashboard.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  void isUserLogin() async {
    await Future.delayed(Duration(seconds: 2));
    if (auth.currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminLoginPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    isUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 65,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            // App Name
            const Text(
              'Smart Campus',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),

            const Text(
              'Companion',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Your Campus. Your Companion.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 35),

            // Loading Indicator
            const SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
