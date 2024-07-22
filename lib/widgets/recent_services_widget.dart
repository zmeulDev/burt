import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecentServicesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
