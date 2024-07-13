import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'styles.dart';
import 'service_dashboard.dart';

class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({Key? key}) : super(key: key);

  Future<void> _deleteService(BuildContext context, String carId, String serviceId) async {
    await FirebaseFirestore.instance
        .collection('cars')
        .doc(carId)
        .collection('services')
        .doc(serviceId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service record deleted successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Service History'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collectionGroup('services').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No service history available'));
          }

          var services = snapshot.data!.docs;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ServiceDashboard(), // Integrate the service dashboard widget
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    var service = services[index];
                    var serviceData = service.data() as Map<String, dynamic>;
                    String carId = service.reference.parent.parent!.id;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(serviceData['serviceName'] ?? 'Unknown Service', style: titleMediumTextStyle),
                            const SizedBox(height: 8),
                            Text(
                              'Date: ${serviceData['serviceDate'] != null ? DateFormat('yyyy-MM-dd').format(serviceData['serviceDate'].toDate()) : 'N/A'}',
                              style: bodyMediumTextStyle,
                            ),
                            Text(
                              'Cost: \$${serviceData['cost']?.toStringAsFixed(2) ?? '0.00'}',
                              style: bodyMediumTextStyle,
                            ),
                            if (serviceData.containsKey('warranty') && serviceData['warranty'] != null)
                              Text(
                                'Warranty: ${serviceData['warranty']}',
                                style: bodyMediumTextStyle,
                              ),
                            if (serviceData.containsKey('notes') && serviceData['notes'] != null)
                              Text(
                                'Notes: ${serviceData['notes']}',
                                style: bodyMediumTextStyle,
                              ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(LineIcons.edit),
                                  onPressed: () {
                                    // Navigate to a screen to edit the service record.
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(LineIcons.trash),
                                  onPressed: () {
                                    _deleteService(context, carId, service.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
