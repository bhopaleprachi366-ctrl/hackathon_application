import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hackathon_application/navigation/bottom_navigation.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      home: const NavigationPage(),
    );
  }
}
