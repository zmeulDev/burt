import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/add_edit_service_screen.dart';

class ServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('services')
            .orderBy('date', descending: true) // Sort by date in descending order
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
                  Text(
                    'Add a new service entry using the button below.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _addService(context),
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Car ID: ${serviceData['carId']}'), // Ideally, show car name or model instead of ID
                    Text('Date: ${serviceData['date']}'),
                    Text('Cost: \$${serviceData['cost']}'),
                    if (serviceData['note'] != null && serviceData['note'].isNotEmpty)
                      Text('Note: ${serviceData['note']}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditServiceScreen(
                        carId: serviceData['carId'],
                        serviceId: serviceData.id,
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('services')
                        .doc(serviceData.id)
                        .delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addService(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addService(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String? selectedCarId;  // Temporarily holds the selected car ID
        return AlertDialog(
          title: Text("Select Car"),
          content: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('cars').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return DropdownButton<String>(
                value: selectedCarId,
                hint: Text('Select a car'),
                onChanged: (String? newValue) {
                  selectedCarId = newValue!;
                },
                items: snapshot.data!.docs.map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                  return DropdownMenuItem<String>(
                    value: document.id,
                    child: Text(document['model']), // Assuming 'model' is a field in each car document
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedCarId != null) {
                  Navigator.pop(dialogContext); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditServiceScreen(carId: selectedCarId!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a car')),
                  );
                }
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog without doing anything
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
