import 'package:flutter/material.dart';

class AppTheme {
  // Define the primary color
  static const Color primaryColor = Color(0xFF4CB6AC);

  // Create a MaterialColor from the primary color
  static final MaterialColor primarySwatch = MaterialColor(
    primaryColor.value,
    const <int, Color>{
      50: Color(0xFFE0F2F0),
      100: Color(0xFFB3E0D9),
      200: Color(0xFF80CCC0),
      300: Color(0xFF4DB8A7),
      400: Color(0xFF26A994),
      500: Color(0xFF4CB6AC), // Primary color
      600: Color(0xFF45AFA5),
      700: Color(0xFF3CA69B),
      800: Color(0xFF339E92),
      900: Color(0xFF248E82),
    },
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      primarySwatch: primarySwatch,
      brightness: Brightness.light,
      // Add more theme customization
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      primarySwatch: primarySwatch,
      brightness: Brightness.dark,
      // Add more theme customization
    );
  }
}
