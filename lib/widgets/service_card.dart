import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  ServiceCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
