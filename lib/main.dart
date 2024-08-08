import 'package:burt/auth_service.dart';
import 'package:burt/login_screen.dart';
import 'package:burt/main_screen.dart';
import 'package:burt/services/car_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BurtCarManagerApp());
}

class BurtCarManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        Provider<CarService>(create: (_) => CarService()),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return MaterialApp(
            title: 'Burt - Car Manager',
            theme:
                _buildTheme(authService.getThemeData(authService.currentTheme)),
            home: StreamBuilder<User?>(
              stream: authService.user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final User? user = snapshot.data;
                  return user == null ? LoginScreen() : MainScreen();
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(ThemeData base) {
    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      primaryTextTheme: GoogleFonts.poppinsTextTheme(base.primaryTextTheme),
    );
  }
}
