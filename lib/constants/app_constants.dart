import 'package:flutter/material.dart';

/// App-wide constants
class AppConstants {
  static const String appName = 'SchemeAssist AI';
  static const String apiBaseUrl = 'http://10.0.2.2:8000';
}

/// Color palette used across the app
class AppColors {
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryDark = Color(0xFF134E4A);
  static const Color navy = Color(0xFF1E293B);
  static const Color surface = Color(0xFFF8FAFB);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMedium = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}

/// Spacing values
class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
}
