import 'package:flutter/material.dart';
import 'package:project/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/signup_page.dart';

import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const SmartCampusApp());
}

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Campus Companion',
      theme: AppTheme.lightTheme,

      // Start with Splash Screen
      home: const SplashScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const SignupPage());
  }
}
