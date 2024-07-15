import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Service Details')),
      body: Column(
        children: [
          ListTile(title: Text('Service Name: Oil Change')),
          ListTile(title: Text('Date: 2023-05-12')),
          ListTile(title: Text('Mileage: 15000')),
          // More details here
          ElevatedButton(onPressed: () {}, child: Text('Edit')),
          ElevatedButton(onPressed: () {}, child: Text('Delete')),
        ],
      ),
    );
  }
}
