import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'styles.dart';
import 'car_details_screen.dart';

class NextDueDates extends StatelessWidget {
  const NextDueDates({Key? key}) : super(key: key);

  bool _isWarning(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now) || date.difference(now).inDays <= 5;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('cars').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        var cars = snapshot.data!.docs;
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Next Due Dates', style: titleLargeTextStyle),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1,
              ),
              itemCount: groupedDueDates.values.length,
              itemBuilder: (context, index) {
                var due = groupedDueDates.values.elementAt(index);
                return _buildDueDateCard(context, due['carId'], due['car'], due['date'], due['type']);
              },
            ),
          ],
        );
      },
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
        elevation: 0, // Flat design
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car, style: titleMediumTextStyle),
                    const SizedBox(height: 8),
                    Text('$type: ${DateFormat('yyyy-MM-dd').format(date)}', style: bodyMediumTextStyle),
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
