import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'styles.dart';
import 'car_details_screen.dart';
import 'service_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  bool _isWarning(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now) || date.difference(now).inDays <= 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          var cars = snapshot.data!.docs;
          int totalCars = cars.length;

          List<Map<String, dynamic>> dueDates = [];
          for (var car in cars) {
            var carData = car.data() as Map<String, dynamic>;
            if (carData['revisionDate'] != null) {
              dueDates.add({
                'carId': car.id,
                'car': carData['model'],
                'date': DateFormat('yyyy-MM-dd').parse(carData['revisionDate']),
                'type': 'Revision'
              });
            }
            if (carData['inspectionDate'] != null) {
              dueDates.add({
                'carId': car.id,
                'car': carData['model'],
                'date': DateFormat('yyyy-MM-dd').parse(carData['inspectionDate']),
                'type': 'Inspection'
              });
            }
            if (carData['insuranceDate'] != null) {
              dueDates.add({
                'carId': car.id,
                'car': carData['model'],
                'date': DateFormat('yyyy-MM-dd').parse(carData['insuranceDate']),
                'type': 'Insurance'
              });
            }
            if (carData['taxDate'] != null) {
              dueDates.add({
                'carId': car.id,
                'car': carData['model'],
                'date': DateFormat('yyyy-MM-dd').parse(carData['taxDate']),
                'type': 'Tax'
              });
            }
          }

          // Group by type and get the nearest date for each type
          Map<String, Map<String, dynamic>> groupedDueDates = {};

          for (var due in dueDates) {
            if (!groupedDueDates.containsKey(due['type']) ||
                due['date'].isBefore(groupedDueDates[due['type']]!['date'])) {
              groupedDueDates[due['type']] = due;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDashboardCard(
                  context,
                  'Total Cars',
                  totalCars.toString(),
                  LineIcons.car,
                  Colors.blue,
                ),
                const ServiceDashboard(), // Integrate the service dashboard widget
                const SizedBox(height: 20),
                const Text('Next Due Dates', style: headingTextStyle),
                const SizedBox(height: 10),
                Column(
                  children: groupedDueDates.values.map((due) {
                    return _buildDueDateCard(context, due['carId'], due['car'], due['date'], due['type']);
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: subheadingTextStyle),
                  const SizedBox(height: 8),
                  Text(value, style: headingTextStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateCard(BuildContext context, String carId, String car, DateTime date, String type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailsScreen(carId: carId),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car, style: subheadingTextStyle),
                    const SizedBox(height: 8),
                    Text('$type: ${DateFormat('yyyy-MM-dd').format(date)}', style: bodyTextStyle),
                  ],
                ),
              ),
              if (_isWarning(date))
                const Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 30,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
