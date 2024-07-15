import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView(
        children: [
          ListTile(title: Text('Upcoming Service: Oil Change')),
          // More notifications
        ],
      ),
    );
  }
}
