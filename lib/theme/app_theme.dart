import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Primary Colors
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color onPrimary = Color(0xFFFFFFFF); // White

  // Secondary Colors
  static const Color secondary = Color(0xFF22C55E); // Green 500
  static const Color accent = Color(0xFFF97316); // Orange 500

  // Neutral Colors
  static const Color background = Color(0xFFF9FAFB); // Gray 50
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF111827); // Gray 900
  static const Color textSecondary = Color(0xFF6B7280); // Gray 500
  static const Color divider = Color(0xFFE5E7EB); // Gray 200

  // Feedback Colors
  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color success = Color(0xFF10B981); // Green 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500

  // Create a MaterialColor from the primary color
  static final MaterialColor primarySwatch = MaterialColor(
    primary.value,
    const <int, Color>{
      50: Color(0xFFEEF2FF),
      100: Color(0xFFE0E7FF),
      200: Color(0xFFC7D2FE),
      300: Color(0xFFA5B4FC),
      400: Color(0xFF818CF8),
      500: Color(0xFF4F46E5), // Primary color
      600: Color(0xFF4338CA),
      700: Color(0xFF3730A3),
      800: Color(0xFF312E81),
      900: Color(0xFF1E1B4B),
    },
  );

  // Status bar style for light theme
  static SystemUiOverlayStyle get lightStatusBarStyle =>
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );

  // Status bar style for dark theme
  static SystemUiOverlayStyle get darkStatusBarStyle =>
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primary,
      primarySwatch: primarySwatch,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        surface: surface,
        background: background,
        error: error,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary),
        displayMedium: TextStyle(color: textPrimary),
        displaySmall: TextStyle(color: textPrimary),
        headlineLarge: TextStyle(color: textPrimary),
        headlineMedium: TextStyle(color: textPrimary),
        headlineSmall: TextStyle(color: textPrimary),
        titleLarge: TextStyle(color: textPrimary),
        titleMedium: TextStyle(color: textPrimary),
        titleSmall: TextStyle(color: textPrimary),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: divider),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: divider),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: error),
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: const TextStyle(color: textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primary,
      primarySwatch: primarySwatch,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D2D2D),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        surface: const Color(0xFF2D2D2D),
        background: const Color(0xFF1A1A1A),
        error: error,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Color(0xFF9CA3AF)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: divider.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: divider.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: error),
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: divider.withOpacity(0.5),
        space: 1,
      ),
    );
  }
}
