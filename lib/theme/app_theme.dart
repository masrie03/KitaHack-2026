import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primaryNavy,
      scaffoldBackgroundColor: AppColors.primaryNavy,
      brightness: Brightness.dark,
      fontFamily: 'Nunito', // Fallback
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentBlue,
        secondary: AppColors.professionalBlue,
        surface: AppColors.secondaryNavy,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
