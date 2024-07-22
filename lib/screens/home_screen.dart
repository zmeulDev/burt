import 'package:burt/widgets/custom_bottom_nav_bar.dart';
import 'package:burt/widgets/recent_services_widget.dart';
import 'package:burt/widgets/service_alerts_widget.dart';
import 'package:burt/widgets/service_card.dart';
import 'package:burt/widgets/upcoming_services_widget.dart';
import 'package:flutter/material.dart';
import 'cars_screen.dart';
import 'service_screen.dart';
import 'profile_screen.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display car information
            Card(
              elevation: 0, // Flat design
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: ListTile(
                title: Text(
                  'Your Car',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                subtitle: Text(
                  'Model: Year',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Sections for services
            ServiceCard(
              title: 'Upcoming Services',
              onTap: () {},
              content: UpcomingServicesWidget(),
            ),
            ServiceCard(
              title: 'Recent Services',
              onTap: () {},
              content: RecentServicesWidget(),
            ),
            ServiceCard(
              title: 'Service Alerts',
              onTap: () {},
              content: ServiceAlertsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
