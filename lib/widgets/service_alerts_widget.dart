import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ServiceAlertsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
