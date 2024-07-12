import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_edit_service_screen.dart';

class ServiceListScreen extends StatelessWidget {
  final String carId;

  ServiceListScreen({required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('services')
            .where('carId', isEqualTo: carId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.build, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No service history found',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditServiceScreen(carId: carId),
                        ),
                      );
                    },
                    child: Text('Add Service'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var serviceData = snapshot.data!.docs[index];
              return ListTile(
                title: Text(serviceData['serviceName']),
                subtitle: Text('Date: ${serviceData['date']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditServiceScreen(
                        carId: carId,
                        serviceId: serviceData.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
