import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'styles.dart';
import 'car_form.dart';
import 'cars_screen.dart';
import 'service_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final String carId;

  const CarDetailsScreen({Key? key, required this.carId}) : super(key: key);

  Future<void> _deleteCar(BuildContext context) async {
    await FirebaseFirestore.instance.collection('cars').doc(carId).delete();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Car deleted successfully'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CarsScreen()),
      );
    });
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: Colors.blueGrey),
            const SizedBox(height: 8),
            Text(label, style: subheadingTextStyle, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Flexible(
              child: Text(value, style: headingTextStyle, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LineIcons.edit),
            onPressed: () async {
              var carSnapshot = await FirebaseFirestore.instance.collection('cars').doc(carId).get();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarForm(car: carSnapshot),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(LineIcons.trash),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Car'),
                  content: const Text('Are you sure you want to delete this car?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteCar(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('cars').doc(carId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Car not found'));
          }
          var car = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/car_image.svg', // Replace with relevant car image
                  height: 200,
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildDetailItem(LineIcons.car, "Manufacture", car['manufacture']),
                    _buildDetailItem(LineIcons.alternateTachometer, "Model", car['model']),
                    _buildDetailItem(LineIcons.calendar, "Year", car['year'].toString()),
                    _buildDetailItem(LineIcons.cogs, "Transmission", car['transmission']),
                    _buildDetailItem(LineIcons.alternateTachometer, "Engine Capacity", car['engineCapacity'].toString()),
                    _buildDetailItem(LineIcons.gasPump, "Fuel Type", car['fuelType']),
                    _buildDetailItem(LineIcons.carSide, "Car Plates", car['carPlates']),
                    _buildDetailItem(LineIcons.calendarCheck, "Inspection Date", car['inspectionDate']),
                    _buildDetailItem(LineIcons.calendarCheck, "Revision Date", car['revisionDate']),
                    _buildDetailItem(LineIcons.calendarCheck, "Insurance Date", car['insuranceDate']),
                    _buildDetailItem(LineIcons.calendarCheck, "Tax Date", car['taxDate']),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LineIcons.clipboard, size: 28, color: Colors.blueGrey),
                            const SizedBox(width: 16),
                            Text("Notes", style: subheadingTextStyle),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(car['notes'], style: bodyTextStyle),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0), backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceScreen(carId: carId),
                      ),
                    );
                  },
                  child: Text('View Service History', style: buttonTextStyle),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
