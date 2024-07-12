import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'car_details_screen.dart';

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
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: _buildUpcomingEventCards(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUpcomingEventCards(BuildContext context) {
    List<Widget> eventCards = [];
    DateTime now = DateTime.now();

    upcomingEvents!.forEach((type, event) {
      if (event.isNotEmpty) {
        DateTime eventDate = event['date'];
        bool isUrgent = eventDate.isBefore(now.add(Duration(days: 7)));

        eventCards.add(
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailsScreen(carId: event['carId']),
                ),
              );
            },
            child: Card(
              color: isUrgent ? Colors.red[100] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$type - ${event['car']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isUrgent ? Colors.red : Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${eventDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isUrgent ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });

    return eventCards;
  }
}
