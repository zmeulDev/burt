import 'package:flutter/material.dart';

class DetailsTab extends StatelessWidget {
  final Map<String, dynamic> carData;

  DetailsTab({required this.carData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(context, 'Year', carData['year']),
          _buildDetailRow(context, 'Engine Size', carData['engineSize']),
          _buildDetailRow(context, 'Fuel Type', carData['fuelType']),
          _buildDetailRow(context, 'Transmission', carData['transmission']),
          _buildDetailRow(context, 'VIN', carData['vin']),
          _buildDetailRow(context, 'Tire Size', carData['tireSize']),
          _buildDetailRow(context, 'Wiper Size', carData['wiperSize']),
          _buildDetailRow(context, 'Bought Date', carData['boughtDate']),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value != null ? value.toString() : 'N/A',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
