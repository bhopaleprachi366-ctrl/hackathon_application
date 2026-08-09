import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextTheme {
  static final TextTheme textTheme = GoogleFonts.poppinsTextTheme().copyWith(
    bodyLarge: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w700),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textColor,
    ),
  );
}
