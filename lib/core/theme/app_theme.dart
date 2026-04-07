import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _primaryColor = Color(0xFF1A1B2E);
  static const _accentColor = Color(0xFF6C63FF);
  static const _successColor = Color(0xFF4CAF50);
  static const _warningColor = Color(0xFFFFA726);
  static const _dangerColor = Color(0xFFEF5350);
  static const _surfaceColor = Color(0xFF252640);
  static const _cardColor = Color(0xFF2D2E4A);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _primaryColor,
        primaryColor: _accentColor,
        colorScheme: const ColorScheme.dark(
          primary: _accentColor,
          secondary: _accentColor,
          surface: _surfaceColor,
          error: _dangerColor,
        ),
        cardTheme: const CardThemeData(
          color: _cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _primaryColor,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white60,
          ),
        ),
      );

  static Color riskColor(double score) {
    if (score < 0.3) return _successColor;
    if (score < 0.5) return const Color(0xFF8BC34A);
    if (score < 0.7) return _warningColor;
    if (score < 0.85) return const Color(0xFFFF7043);
    return _dangerColor;
  }

  static Color get success => _successColor;
  static Color get warning => _warningColor;
  static Color get danger => _dangerColor;
  static Color get accent => _accentColor;
  static Color get card => _cardColor;
  static Color get surface => _surfaceColor;
}
