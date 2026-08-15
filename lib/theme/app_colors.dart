import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF1D4ED8);
  static const Color accent = Color(0xFF60A5FA);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);

  static const Color success = Color(0xFF16A34A);
  static const Color error = Color(0xFFDC2626);

  static const LinearGradient blueGradient = LinearGradient(
    colors: [
      Color(0xFF2563EB),
      Color(0xFF1D4ED8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}