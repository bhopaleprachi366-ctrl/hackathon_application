import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/theme/app_colors.dart';
import 'package:project/theme/app_text_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: GoogleFonts.spaceGroteskTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      titleTextStyle: TextStyle(color: AppColors.surface),
    ),
    //textTheme: AppTextTheme.textTheme,
  );
}
