import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_application/navigation/bottom_navigation.dart';
import 'package:hackathon_application/screens/vendor/vendor_dashboard.dart';
import 'onboarding_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        checkUser();
      },
    );
  }

  Future<void> checkUser() async {
    // Check if someone is already logged in
    User? user = FirebaseAuth.instance.currentUser;

    // No user logged in
    if (user == null) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingPage(),
        ),
      );

      return;
    }

    try {
      // Get user's data from Firestore
      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!mounted) return;

      if (!userDocument.exists) {
        // User is logged in but profile doesn't exist
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingPage(),
          ),
        );

        return;
      }

      Map<String, dynamic> userData =
          userDocument.data() as Map<String, dynamic>;

      String role = userData["role"] ?? "";

      // CUSTOMER
      if (role == "customer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationPage(),
          ),
        );
      }

      // VENDOR
      else if (role == "vendor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VendorDashboard(),
          ),
        );
      }

      // Invalid role
      else {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingPage(),
          ),
        );
      }
    } catch (e) {
      // If something goes wrong, send user to onboarding
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.repeat,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              "SubServe",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Manage your subscriptions easily",
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}