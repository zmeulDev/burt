import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'service_utils.dart';
import 'styles.dart';

class ServiceDashboard extends StatelessWidget {
  const ServiceDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: Future.wait([calculateTotalServiceEntries(), calculateTotalServiceCost()]).then((values) {
        return {'entries': values[0], 'cost': values[1]};
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error calculating totals'));
        }
        int totalServiceEntries = snapshot.data?['entries'] ?? 0;
        double totalServiceCost = snapshot.data?['cost'] ?? 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDashboardCard(
              context,
              'Total Service Entries',
              totalServiceEntries.toString(),
              LineIcons.wrench,
              Colors.green,
            ),
            _buildDashboardCard(
              context,
              'Total Service Cost',
              '\$${totalServiceCost.toStringAsFixed(2)}',
              LineIcons.dollarSign,
              Colors.orange,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: subheadingTextStyle),
                  const SizedBox(height: 8),
                  Text(value, style: headingTextStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
