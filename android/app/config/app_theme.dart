// lib/app/config/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue.shade700, // A bit darker blue
    scaffoldBackgroundColor: Colors.grey[100], // Light grey background
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.blue.shade700,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue.shade700,
        side: BorderSide(color: Colors.blue.shade700),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade700),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue.shade700,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade700,
      secondary: Colors.blue.shade300,
      surface: Colors.white,
      background: Colors.grey[100]!,
      error: Colors.red.shade700,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
    ),
    // fontFamily: 'YourCustomFont', // if you have one
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue.shade300,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.grey[850],
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    ),
    // ... define other dark theme properties similarly
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade300,
      secondary: Colors.blue.shade700,
      surface: Colors.grey[800]!,
      background: Colors.grey[900]!,
      error: Colors.red.shade400,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
    ),
  );
}