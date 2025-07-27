import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF4A90E2); // Xanh da trời nhẹ nhàng
  static const Color secondary = Color(0xFFF5A623); // Cam năng lượng
  static const Color background = Color(0xFFF7F9FC); // Trắng-xám tinh tế
  static const Color accent = Color(0xFF7ED6DF); // Xanh pastel thư giãn
  static const Color text = Color(0xFF222B45); // Đen-xám hiện đại
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFEB5757);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: background,
      surface: Colors.white,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: text,
      onSurface: text,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: background,
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 2,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin: EdgeInsets.all(8),
      shadowColor: Color(0xFF4A90E2),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accent, width: 0.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      labelStyle: TextStyle(color: text.withOpacity(0.7)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: accent.withOpacity(0.15),
      selectedColor: primary.withOpacity(0.15),
      labelStyle: const TextStyle(color: text),
      secondaryLabelStyle: const TextStyle(color: primary),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondary,
      foregroundColor: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: accent,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: text,
        fontSize: 20,
      ),
      bodyMedium: TextStyle(color: text, fontSize: 16),
      titleMedium: TextStyle(color: text, fontSize: 14),
      labelLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
    dividerColor: accent,
    iconTheme: const IconThemeData(color: primary),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      background: const Color(0xFF23272F),
      surface: const Color(0xFF23272F),
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF23272F),
    cardColor: const Color(0xFF2C313A),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF23272F),
      elevation: 2,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin: EdgeInsets.all(8),
      shadowColor: Color(0xFF4A90E2),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C313A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accent, width: 0.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.white70),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: accent.withOpacity(0.15),
      selectedColor: primary.withOpacity(0.15),
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: primary),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondary,
      foregroundColor: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF2C313A),
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: accent,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
      titleMedium: TextStyle(color: Colors.white, fontSize: 14),
      labelLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
    dividerColor: accent,
    iconTheme: const IconThemeData(color: primary),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
