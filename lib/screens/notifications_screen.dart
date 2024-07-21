import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
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
              leading: Icon(LineIcons.bell, color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Upcoming Service: Oil Change',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          // More notifications can be added here
        ],
      ),
    );
  }
}
