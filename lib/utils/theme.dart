import 'package:flutter/material.dart';

class AppTheme {
  static const Color yellow = Color(0xFFFFD700);
  static const Color skyBlue = Color(0xFF87CEEB);
  static const Color purple = Color(0xFF9B59B6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softPink = Color(0xFFFFB6C1);
  static const Color orange = Color(0xFFFF8C00);
  static const Color green = Color(0xFF4CAF50);
  static const Color red = Color(0xFFFF6B6B);
  static const Color darkPurple = Color(0xFF6C3483);
  static const Color lightYellow = Color(0xFFFFF3CD);
  static const Color lightBlue = Color(0xFFD6EAF8);
  static const Color lightPink = Color(0xFFFFE0E6);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: white,
        colorScheme: ColorScheme.light(
          primary: purple,
          secondary: skyBlue,
          tertiary: yellow,
          surface: white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: white,
          foregroundColor: purple,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: yellow,
            foregroundColor: darkPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            elevation: 4,
          ),
        ),
      );

  static List<Color> getGradient(String topic) {
    switch (topic) {
      case 'English':
        return [purple, const Color(0xFF8E44AD)];
      case 'Math':
        return [skyBlue, const Color(0xFF5DADE2)];
      case 'Arabic':
        return [const Color(0xFF2ECC71), const Color(0xFF1ABC9C)];
      case 'Games':
        return [yellow, orange];
      case 'Rewards':
        return [yellow, orange];
      case 'Settings':
        return [softPink, purple];
      default:
        return [purple, skyBlue];
    }
  }

  static Color getTopicColor(String topic) {
    switch (topic) {
      case 'Alphabet':
      case 'Animals':
        return purple;
      case 'Vocabulary':
      case 'Fruits':
        return Colors.orange;
      case 'Tracing':
      case 'Colors':
        return skyBlue;
      case 'Counting':
        return green;
      case 'Addition':
        return Colors.blue;
      case 'Subtraction':
        return red;
      case 'Shapes':
        return purple;
      case 'Number Match':
        return orange;
      case 'Phonics':
        return const Color(0xFFFF6B9D);
      case 'Sight Words':
        return const Color(0xFF6A0572);
      case 'Spelling':
        return const Color(0xFF00B4D8);
      case 'Body Parts':
        return const Color(0xFFE76F51);
      case 'Vegetables':
        return const Color(0xFF2A9D8F);
      case 'Matching':
        return const Color(0xFFE9C46A);
      case 'Multiplication':
        return const Color(0xFF9C27B0);
      case 'Division':
        return const Color(0xFFFF5722);
      case 'Skip Counting':
        return const Color(0xFF00BCD4);
      case 'Comparison':
        return const Color(0xFFFF9800);
      case 'Clock':
        return const Color(0xFF3F51B5);
      case 'Measurement':
        return const Color(0xFF8BC34A);
      case 'Count & Tap':
        return const Color(0xFFFF4081);
      case 'Arabic Alphabet':
      case 'Arabic Animals':
        return const Color(0xFF2ECC71);
      case 'Arabic Vocabulary':
      case 'Arabic Fruits':
        return const Color(0xFF1ABC9C);
      case 'Arabic Tracing':
      case 'Arabic Colors':
        return const Color(0xFF16A085);
      case 'Arabic Body Parts':
        return const Color(0xFF27AE60);
      default:
        return purple;
    }
  }
}
