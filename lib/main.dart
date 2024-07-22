

import 'package:flutter/material.dart';
import 'package:burt/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = ThemeData.light().textTheme;

    return MaterialApp(
      title: 'Burt Car Management',
      theme: MaterialTheme(textTheme).lightHighContrast(), // Use the light theme
      home: LoginScreen(),
    );
  }
}
