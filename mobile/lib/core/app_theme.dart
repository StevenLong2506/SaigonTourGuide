import 'package:flutter/material.dart';

class AppColors{
  AppColors._();
  static const oceanTeal = Color(0xFF0E8A85);
  static const sunsetCoral = Color(0xFFFF7A59);
  static const sandyGold = Color(0xFFF2B134);
}

class AppTheme {
  AppTheme._();
  static ThemeData light(){
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.oceanTeal,
      brightness: Brightness.light
    ).copyWith(
      secondary: AppColors.sunsetCoral,
      onSecondary: Colors.white,
      tertiary: AppColors.sandyGold,
      onTertiary: Colors.black
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.secondaryContainer,
        backgroundColor: colorScheme.surface,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none
        ),
      ),
    );
  }
}