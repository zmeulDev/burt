import 'package:burt/widgets/service_expenses_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_service_record_screen.dart';
import 'service_detail_screen.dart';

class ServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Service History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('services')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('date', descending: true)
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No service records found.',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add a service record to keep track of your car maintenance.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }
          final services = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index].data() as Map<String, dynamic>;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('cars').doc(service['carId']).get(),
                builder: (context, carSnapshot) {
                  if (carSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (carSnapshot.hasError) {
                    return Center(child: Text('Error: ${carSnapshot.error}'));
                  }
                  if (!carSnapshot.hasData || !carSnapshot.data!.exists) {
                    return Center(child: Text('Car not found.'));
                  }
                  final carData = carSnapshot.data!.data() as Map<String, dynamic>;
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: ListTile(
                      title: Text(
                        service['serviceName'] ?? 'N/A',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      subtitle: Text(
                        'Car: ${carData['model'] ?? 'N/A'}, Date: ${service['date'] ?? 'N/A'}, Mileage: ${service['mileage'] ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailScreen(serviceId: services[index].id),
                          ),
                        );
                      },
                    ),
                  );

                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).cardColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddServiceRecordScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
