import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, Map<String, dynamic>>? upcomingEvents;

  @override
  void initState() {
    super.initState();
    fetchUpcomingDates().then((events) {
      setState(() {
        upcomingEvents = events;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: upcomingEvents == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Dates:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (upcomingEvents!['Insurance']!.isNotEmpty)
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text('Insurance - ${upcomingEvents!['Insurance']!['car']}'),
                  subtitle: Text(
                    'Date: ${upcomingEvents!['Insurance']!['date'].toLocal().toString().split(' ')[0]}',
                  ),
                  leading: Icon(Icons.event, color: Colors.green),
                ),
              ),
            if (upcomingEvents!['Inspection']!.isNotEmpty)
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text('Inspection - ${upcomingEvents!['Inspection']!['car']}'),
                  subtitle: Text(
                    'Date: ${upcomingEvents!['Inspection']!['date'].toLocal().toString().split(' ')[0]}',
                  ),
                  leading: Icon(Icons.event, color: Colors.green),
                ),
              ),
            if (upcomingEvents!['Tax']!.isNotEmpty)
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text('Tax - ${upcomingEvents!['Tax']!['car']}'),
                  subtitle: Text(
                    'Date: ${upcomingEvents!['Tax']!['date'].toLocal().toString().split(' ')[0]}',
                  ),
                  leading: Icon(Icons.event, color: Colors.green),
                ),
              ),
            if (upcomingEvents!['Revision']!.isNotEmpty)
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text('Revision - ${upcomingEvents!['Revision']!['car']}'),
                  subtitle: Text(
                    'Date: ${upcomingEvents!['Revision']!['date'].toLocal().toString().split(' ')[0]}',
                  ),
                  leading: Icon(Icons.event, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
