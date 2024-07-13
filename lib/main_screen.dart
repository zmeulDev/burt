import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cars_screen.dart';
import 'service_screen.dart';
import 'profile_screen.dart';
import 'styles.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback toggleThemeMode;

  const MainScreen({Key? key, required this.toggleThemeMode}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String selectedCarId = 'defaultCarId'; // Placeholder for car ID

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CarsScreen(),
    ServiceScreen(carId: 'defaultCarId'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ..._widgetOptions,
          ProfileScreen(toggleThemeMode: widget.toggleThemeMode),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
