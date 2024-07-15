import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CarInfoCard extends StatelessWidget {
  final String model;
  final String carPlate;
  final String nextDueLabel;
  final String nextDueDate;
  final VoidCallback onTap;

  CarInfoCard({
    required this.model,
    required this.carPlate,
    required this.nextDueLabel,
    required this.nextDueDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Icon(
                LineIcons.car,
                size: 120,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Plate: $carPlate',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$nextDueLabel: $nextDueDate',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
