import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'edit_service_record_screen.dart';
import 'car_details_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  ServiceDetailScreen({required this.serviceId});

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  Map<String, dynamic>? serviceData;
  String? carModel;

  @override
  void initState() {
    super.initState();
    _loadServiceDetails();
  }

  Future<void> _loadServiceDetails() async {
    DocumentSnapshot serviceDoc = await FirebaseFirestore.instance.collection('services').doc(widget.serviceId).get();
    var data = serviceDoc.data() as Map<String, dynamic>;
    if (data['carId'] != null) {
      DocumentSnapshot carDoc = await FirebaseFirestore.instance.collection('cars').doc(data['carId']).get();
      setState(() {
        serviceData = data;
        carModel = carDoc['model'];
      });
    } else {
      setState(() {
        serviceData = data;
      });
    }
  }

  Future<void> _deleteService(BuildContext context) async {
    await FirebaseFirestore.instance.collection('services').doc(widget.serviceId).delete();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service record deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Service Details')),
      body: serviceData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (carModel != null)
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      carModel!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.onPrimaryContainer),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetailsScreen(carId: serviceData!['carId']),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListTile(
                title: Text('Service Name', style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(serviceData!['serviceName'], style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListTile(
                title: Text('Date', style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(serviceData!['date'], style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListTile(
                title: Text('Service Type', style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(serviceData!['serviceType'], style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListTile(
                title: Text('Mileage', style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(serviceData!['mileage'], style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListTile(
                title: Text('Cost', style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(serviceData!['cost'], style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListTile(
                title: Text('Notes', style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(serviceData!['notes'], style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditServiceRecordScreen(serviceId: widget.serviceId),
                      ),
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  onPressed: () => _deleteService(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
