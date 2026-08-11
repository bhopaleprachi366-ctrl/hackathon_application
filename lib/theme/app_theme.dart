import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // Font
    fontFamily: 'Poppins',

    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    // Scaffold
    scaffoldBackgroundColor: backgroundColor,
  );
}
