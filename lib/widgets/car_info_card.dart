import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CarInfoCard extends StatelessWidget {
  final String model;
  final String carPlate;
  final String nextDueLabel;
  final String nextDueDate;
  final VoidCallback onTap;

  const CarInfoCard({
    required this.model,
    required this.carPlate,
    required this.nextDueLabel,
    required this.nextDueDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      elevation: 0, // Flat design
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  LineIcons.carCrash,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    carPlate,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$nextDueLabel: $nextDueDate',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
