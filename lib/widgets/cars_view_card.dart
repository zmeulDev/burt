import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class CarsViewCard extends StatelessWidget {
  final String model;
  final String carPlate;
  final bool status;
  final String carId;
  final Function(String) onCarSelected;
  final Map<String, String>? upcomingTax;

  CarsViewCard({
    required this.model,
    required this.carPlate,
    required this.status,
    required this.carId,
    required this.onCarSelected,
    this.upcomingTax,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: status
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: Theme.of(context).colorScheme.surfaceContainerLowest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: status
                      ? Theme.of(context).colorScheme.surfaceContainer
                      : Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  status ? 'ACTIVE' : 'INACTIVE',
                  style: TextStyle(
                    color: status
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onError,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                '$model',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '$carPlate',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 22,
            ),
          ),
          Divider(),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                radius: 24,
                child: Icon(
                  status ? Iconsax.car_copy : Iconsax.car_copy,
                  color: DateTime.now().isBefore(DateFormat("yyyy-MM-dd")
                          .parse(upcomingTax!['taxValidTo'].toString()))
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                  size: 32,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Tax:',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    upcomingTax != null
                        ? '${upcomingTax!['taxType']}: ${upcomingTax!['taxValidTo'] == '1985-05-20' ? 'N/A' : upcomingTax!['taxValidTo']}'
                        : 'N/A',
                    style: TextStyle(
                      color: DateTime.now().isBefore(DateFormat("yyyy-MM-dd")
                              .parse(upcomingTax!['taxValidTo'].toString()))
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_forward,
                      color: Theme.of(context).colorScheme.onInverseSurface),
                  onPressed: () => onCarSelected(carId),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
