import 'package:burt/screens/edit_car_screen.dart';
import 'package:burt/widgets/car_details_tab.dart';
import 'package:burt/widgets/car_due_dates_tab.dart';
import 'package:burt/widgets/car_service_history_tab.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';



class CarDetailsScreen extends StatelessWidget {
  final String carId;

  CarDetailsScreen({required this.carId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Car Details'),
        ),
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

            return Column(
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
                SizedBox(height: 10),
                TabBar(
                  tabs: [
                    Tab(text: 'Due Dates'),
                    Tab(text: 'Details'),
                    Tab(text: 'Service History'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      DueDatesTab(carData: carData),
                      DetailsTab(carData: carData),
                      ServiceHistoryTab(carId: carId),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
