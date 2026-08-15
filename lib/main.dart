
import 'package:flutter/material.dart';
import 'package:hackathon_application/customer_side/homepage.dart';
import 'package:hackathon_application/navigation/bottom_navigation.dart';

void main() {
  runApp(const SubServeApp());
}

class SubServeApp extends StatelessWidget {
  const SubServeApp({super.key});

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_application/screens/login_page.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


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
}
