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
    return GestureDetector(
      onTap: () => onCarSelected(carId),
      child: Container(
        width: 350,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: status ? Colors.teal : Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    status ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '$model',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '$carPlate',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Divider(),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    status ? Iconsax.car_copy : Iconsax.car_copy,
                    color: DateTime.now().isBefore(DateFormat("yyyy-MM-dd")
                            .parse(upcomingTax!['taxValidTo'].toString()))
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                    size: 36,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Tax:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      upcomingTax != null
                          ? '${upcomingTax!['taxType']}: ${upcomingTax!['taxValidTo'] == '1985-05-20' ? 'N/A' : upcomingTax!['taxValidTo']}'
                          : 'N/A',
                      style: TextStyle(
                        color: DateTime.now().isBefore(DateFormat("yyyy-MM-dd")
                                .parse(upcomingTax!['taxValidTo'].toString()))
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.onPrimary),
                    onPressed: () => onCarSelected(carId),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
