import 'package:flutter/material.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback toggleThemeMode;

  const LoginScreen({Key? key, required this.toggleThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the MainScreen and pass the toggleThemeMode callback
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(toggleThemeMode: toggleThemeMode),
              ),
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
