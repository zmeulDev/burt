import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'add_car_screen.dart';
import 'car_details_screen.dart';
import '../widgets/car_info_card.dart'; // Import the CarInfoCard widget
import '../theme.dart'; // Import the theme

class CarsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cars')),
      body: StreamBuilder(
        stream: _firestore.collection('cars').where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/no_cars.svg', // Ensure this SVG is in your assets folder
                      height: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No cars found.',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Add a car to keep track of your service history.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final nextDueData = _getNextDueData(doc);

              return CarInfoCard(
                model: doc['model'],
                carPlate: doc['carPlate'],
                nextDueLabel: nextDueData['label']!,
                nextDueDate: nextDueData['date']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarDetailsScreen(carId: doc.id),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCarScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Map<String, String> _getNextDueData(DocumentSnapshot doc) {
    final taxDue = doc['taxDue'] != null ? DateTime.tryParse(doc['taxDue']) : null;
    final insuranceDue = doc['insuranceDue'] != null ? DateTime.tryParse(doc['insuranceDue']) : null;
    final serviceDue = doc['serviceDue'] != null ? DateTime.tryParse(doc['serviceDue']) : null;
    final inspectionDue = doc['inspectionDue'] != null ? DateTime.tryParse(doc['inspectionDue']) : null;

    final now = DateTime.now();

    final dueDates = {
      'Tax Due': taxDue,
      'Insurance Due': insuranceDue,
      'Service Due': serviceDue,
      'Inspection Due': inspectionDue,
    };

    String nextDueLabel = '';
    DateTime? nextDueDate;

    dueDates.forEach((label, date) {
      if (date != null && date.isAfter(now) && (nextDueDate == null || (nextDueDate != null && date.isBefore(nextDueDate!)))) {
        nextDueLabel = label;
        nextDueDate = date;
      }
    });

    return {
      'label': nextDueLabel,
      'date': nextDueDate != null ? nextDueDate!.toLocal().toString().split(' ')[0] : 'N/A',
    };
  }
}
