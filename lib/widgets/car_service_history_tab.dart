import 'package:burt/screens/service_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceHistoryTab extends StatelessWidget {
  final String carId;

  ServiceHistoryTab({required this.carId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('services').where('carId', isEqualTo: carId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No service history available.'));
        }

        var services = snapshot.data!.docs;

        return ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            var serviceData = services[index].data() as Map<String, dynamic>;
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: ListTile(
                title: Text(serviceData['serviceName'] ?? 'N/A'),
                subtitle: Text(serviceData['date'] ?? 'N/A'),
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
  }
}
