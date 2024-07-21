import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              content: _buildUpcomingServices(context),
            ),
            ServiceCard(
              title: 'Recent Services',
              onTap: () {},
              content: _buildRecentServices(context),
            ),
            ServiceCard(
              title: 'Service Alerts',
              onTap: () {},
              content: _buildServiceAlerts(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingServices(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cars')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No upcoming services.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        final services = snapshot.data!.docs.where((doc) {
          final car = doc.data() as Map<String, dynamic>;
          if (car['serviceDue'] != null) {
            final serviceDueDate = DateTime.tryParse(car['serviceDue']);
            if (serviceDueDate != null) {
              return serviceDueDate.isAfter(DateTime.now());
            }
          }
          return false;
        }).toList()
          ..sort((a, b) {
            final carA = a.data() as Map<String, dynamic>;
            final carB = b.data() as Map<String, dynamic>;
            return DateTime.parse(carA['serviceDue']).compareTo(DateTime.parse(carB['serviceDue']));
          });
        return Column(
          children: services.map((doc) {
            final car = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(car['model'] ?? 'N/A'),
              subtitle: Text(car['serviceDue'] ?? 'N/A'),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRecentServices(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('services')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('date', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No recent services.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        final services = snapshot.data!.docs;
        return Column(
          children: services.map((doc) {
            final service = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(service['name'] ?? 'N/A'),
              subtitle: Text(service['date'] ?? 'N/A'),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildServiceAlerts(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cars')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No service alerts.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        final services = snapshot.data!.docs.where((doc) {
          final car = doc.data() as Map<String, dynamic>;
          if (car['serviceDue'] != null) {
            final serviceDueDate = DateTime.tryParse(car['serviceDue']);
            if (serviceDueDate != null) {
              return serviceDueDate.isBefore(DateTime.now());
            }
          }
          return false;
        }).toList()
          ..sort((a, b) {
            final carA = a.data() as Map<String, dynamic>;
            final carB = b.data() as Map<String, dynamic>;
            return DateTime.parse(carA['serviceDue']).compareTo(DateTime.parse(carB['serviceDue']));
          });
        return Column(
          children: services.map((doc) {
            final car = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(car['model'] ?? 'N/A'),
              subtitle: Text(car['serviceDue'] ?? 'N/A'),
            );
          }).toList(),
        );
      },
    );
  }
}
