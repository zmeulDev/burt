import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6200EE); // Primary color from the image
const Color secondaryColor = Color(0xFF03DAC6); // Secondary color from the image
const Color backgroundColor = Color(0xFFF6F6F6); // Light background color from the image
const Color cardColor = Colors.white;
const Color textColor = Color(0xFF000000); // Dark text color
const Color accentColor = Color(0xFF6200EE); // Accent color for buttons

const TextStyle titleLargeTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: textColor,
);

const TextStyle titleMediumTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: textColor,
);

const TextStyle bodyLargeTextStyle = TextStyle(
  fontSize: 18,
  color: textColor,
);

const TextStyle bodyMediumTextStyle = TextStyle(
  fontSize: 16,
  color: textColor,
);

const TextStyle linkTextStyle = TextStyle(
  fontSize: 16,
  color: primaryColor,
  decoration: TextDecoration.underline,
);

const EdgeInsets cardPadding = EdgeInsets.all(16.0);

final ThemeData lightTheme = ThemeData(
  primaryColor: primaryColor,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    background: backgroundColor,
    surface: cardColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textColor,
    onBackground: textColor,
  ),
  scaffoldBackgroundColor: backgroundColor,
  cardColor: cardColor,
  textTheme: const TextTheme(
    headlineLarge: titleLargeTextStyle,
    headlineMedium: titleMediumTextStyle,
    bodyLarge: bodyLargeTextStyle,
    bodyMedium: bodyMediumTextStyle,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0, // Flat design
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: cardColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: textColor.withOpacity(0.7),
    elevation: 0, // Flat design
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    color: cardColor,
    elevation: 0, // Flat design
    margin: const EdgeInsets.symmetric(vertical: 8.0),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    background: Colors.black,
    surface: Colors.grey[800]!,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.grey[800]!,
  textTheme: const TextTheme(
    headlineLarge: titleLargeTextStyle,
    headlineMedium: titleMediumTextStyle,
    bodyLarge: bodyLargeTextStyle,
    bodyMedium: bodyMediumTextStyle,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0, // Flat design
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[800]!,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey[600]!, // Adjusted for better visibility
    elevation: 0, // Flat design
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    color: Colors.grey[800]!,
    elevation: 0, // Flat design
    margin: const EdgeInsets.symmetric(vertical: 8.0),
  ),
);
