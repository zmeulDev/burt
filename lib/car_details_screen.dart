import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_car_screen.dart';
import 'screens/service_list_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final String carId;

  CarDetailsScreen({required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCarScreen(carId: carId),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool confirmed = await _showConfirmationDialog(context, 'Are you sure you want to delete this car?') ?? false;
              if (confirmed) {
                await FirebaseFirestore.instance.collection('cars').doc(carId).delete();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('cars').doc(carId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred.'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Car not found or deleted.'));
          }

          var carData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('Manufacture: ${carData['manufacture']}'),
                Text('Model: ${carData['model']}'),
                Text('Year: ${carData['year']}'),
                Text('Engine: ${carData['engine']}'),
                Text('Transmission: ${carData['transmission']}'),
                Text('Plates: ${carData['plates']}'),
                Text('Next Insurance Date: ${carData['nextInsuranceDate']}'),
                Text('Next Inspection Date: ${carData['nextInspectionDate']}'),
                Text('Next Tax Date: ${carData['nextTaxDate']}'),
                Text('Next Revision Date: ${carData['nextRevisionDate']}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceListScreen(carId: carId),
                      ),
                    );
                  },
                  child: Text('View Service History'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String message) async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    )) ?? false;
  }
}
