import 'package:burt/screens/add_edit_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_car_screen.dart';
import 'screens/service_list_screen.dart'; // Import the screen to add service

class CarDetailsScreen extends StatelessWidget {
  final String carId;

  CarDetailsScreen({required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCarScreen(carId: carId),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('cars').doc(carId).delete();
                    Navigator.pop(context); // Go back to the previous screen after deletion
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                SizedBox(height: 20),
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
        },
      ),
    );
  }
}
