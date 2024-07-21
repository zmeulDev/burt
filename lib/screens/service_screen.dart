import 'package:flutter/material.dart';
import 'add_service_record_screen.dart';
import 'service_detail_screen.dart';
import '../theme.dart'; // Import the theme

class ServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Service History')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: ListTile(
              title: Text(
                'Oil Change',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Text(
                'Date: 2023-05-12, Mileage: 15000',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailScreen()));
              },
            ),
          ),
          // More entries
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddServiceRecordScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
