import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      surface: AppColors.surface,
      surfaceContainerHighest: AppColors.surfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Inter',
      textTheme: _textTheme(AppColors.onSurface),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface.withValues(alpha: 0.76),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF2A2640),
        contentTextStyle: TextStyle(color: Color(0xFFF5F0FF)),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFFA89BFF),
      primaryContainer: const Color(0xFF3B2F7A),
      secondary: const Color(0xFFFFB59B),
      tertiary: const Color(0xFF7CDCC8),
      error: const Color(0xFFFF8A8A),
      surface: AppColors.darkSurface,
      surfaceContainerHighest: const Color(0xFF2A2638),
      outline: const Color(0xFF3F3A4F),
      outlineVariant: const Color(0xFF2F2A3D),
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: 'Inter',
      textTheme: _textTheme(AppColors.darkOnSurface),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  static TextTheme _textTheme(Color textColor) {
    return TextTheme(
      headlineLarge: TextStyle(fontSize: 32, height: 1.25, fontWeight: FontWeight.w600, color: textColor),
      headlineSmall: TextStyle(fontSize: 24, height: 1.33, fontWeight: FontWeight.w600, color: textColor),
      titleLarge: TextStyle(fontSize: 22, height: 1.27, fontWeight: FontWeight.w600, color: textColor),
      titleMedium: TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w600, letterSpacing: 0.15, color: textColor),
      titleSmall: TextStyle(fontSize: 14, height: 1.43, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: textColor),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, letterSpacing: 0.5, color: textColor),
      bodyMedium: TextStyle(fontSize: 14, height: 1.43, letterSpacing: 0.25, color: textColor),
      bodySmall: TextStyle(fontSize: 12, height: 1.33, letterSpacing: 0.4, color: textColor),
      labelLarge: TextStyle(fontSize: 14, height: 1.43, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: textColor),
      labelMedium: TextStyle(fontSize: 12, height: 1.33, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: textColor),
      labelSmall: TextStyle(fontSize: 11, height: 1.45, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: textColor),
    );
  }
}
