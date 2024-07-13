import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main_screen.dart';
import 'styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Burt',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: MainScreen(toggleThemeMode: _toggleThemeMode),
    );
  }
}
