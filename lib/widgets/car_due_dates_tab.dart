import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DueDatesTab extends StatelessWidget {
  final Map<String, dynamic> carData;

  DueDatesTab({required this.carData});

  @override
  Widget build(BuildContext context) {
    // Create a list of due dates
    List<Map<String, dynamic>> dueDates = [
      {'label': 'Next Tax', 'date': carData['taxDue'], 'icon': LineIcons.moneyBill},
      {'label': 'Next Insurance', 'date': carData['insuranceDue'], 'icon': LineIcons.userShield},
      {'label': 'Next Service', 'date': carData['serviceDue'], 'icon': LineIcons.tools},
      {'label': 'Next Inspection', 'date': carData['inspectionDue'], 'icon': LineIcons.search},
    ];

    // Sort the due dates in descending order
    dueDates.sort((a, b) => (b['date'] ?? '').compareTo(a['date'] ?? ''));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: dueDates.length,
                itemBuilder: (context, index) {
                  final dueDate = dueDates[index];
                  return _buildTimelineItem(context, dueDate['label'], dueDate['date'], dueDate['icon']);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String label, dynamic date, IconData icon) {
    bool isFutureDate = date != null && DateTime.tryParse(date)!.isAfter(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isFutureDate ? Theme.of(context).colorScheme.error.withOpacity(0.2) : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  date != null ? date.toString() : 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
