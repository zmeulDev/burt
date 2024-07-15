import 'package:flutter/material.dart';
import 'cars_screen.dart';
import 'service_screen.dart';
import 'profile_screen.dart';
import '../widgets/service_card.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeContentScreen(),
    CarsScreen(),
    ServiceScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Burt'),
        actions: [IconButton(icon: Icon(Icons.notifications), onPressed: () {})],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Display car information
          Card(
            child: ListTile(
              title: Text('Your Car'),
              subtitle: Text('Model: Year'),
            ),
          ),
          // Sections for services
          ServiceCard(title: 'Upcoming Services', onTap: () {}),
          ServiceCard(title: 'Recent Services', onTap: () {}),
          ServiceCard(title: 'Service Alerts', onTap: () {}),
        ],
      ),
    );
  }
}
