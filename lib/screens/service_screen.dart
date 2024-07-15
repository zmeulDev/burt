import 'package:flutter/material.dart';
import 'add_service_record_screen.dart';
import 'service_detail_screen.dart';

class ServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Service History')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Oil Change'),
            subtitle: Text('Date: 2023-05-12, Mileage: 15000'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailScreen()));
            },
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
