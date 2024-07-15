import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';
import 'edit_car_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final String carId;

  CarDetailsScreen({required this.carId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: Text('Car Details')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('cars').doc(carId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Car not found.'));
          }

          var carData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          LineIcons.car,
                          size: 100,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            carData['maker'] ?? 'N/A',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            carData['model'] ?? 'N/A',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: 10),
                          Text(
                            carData['carPlate'] ?? 'N/A',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCarScreen(carId: carId),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _firestore.collection('cars').doc(carId).delete();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car deleted successfully')));
                      },
                      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildDetailRow(context, 'Year', carData['year']),
                _buildDetailRow(context, 'Engine Size', carData['engineSize']),
                _buildDetailRow(context, 'Fuel Type', carData['fuelType']),
                _buildDetailRow(context, 'Transmission', carData['transmission']),
                _buildDetailRow(context, 'VIN', carData['vin']),
                _buildDetailRow(context, 'Tire Size', carData['tireSize']),
                _buildDetailRow(context, 'Wiper Size', carData['wiperSize']),
                _buildDetailRow(context, 'Bought Date', carData['boughtDate']),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Due Dates', style: Theme.of(context).textTheme.titleLarge),
                      _buildDetailRow(context, 'Next Tax Due', carData['taxDue']),
                      _buildDetailRow(context, 'Next Insurance Due', carData['insuranceDue']),
                      _buildDetailRow(context, 'Next Service Due', carData['serviceDue']),
                      _buildDetailRow(context, 'Next Inspection Due', carData['inspectionDue']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value != null ? value.toString() : 'N/A',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
