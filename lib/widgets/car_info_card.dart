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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                LineIcons.car,
                size: 40,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
              SizedBox(width: 16),
              Expanded(
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
              Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
