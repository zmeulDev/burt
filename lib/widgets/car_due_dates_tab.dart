import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DueDatesTab extends StatelessWidget {
  final Map<String, dynamic> carData;

  DueDatesTab({required this.carData});

  @override
  Widget build(BuildContext context) {
    // Create a list of due dates
    List<Map<String, dynamic>> dueDates = [
      {'label': 'Next Tax Due', 'date': carData['taxDue'], 'icon': LineIcons.moneyBill, 'step': 1},
      {'label': 'Next Insurance Due', 'date': carData['insuranceDue'], 'icon': LineIcons.userShield, 'step': 2},
      {'label': 'Next Service Due', 'date': carData['serviceDue'], 'icon': LineIcons.tools, 'step': 3},
      {'label': 'Next Inspection Due', 'date': carData['inspectionDue'], 'icon': LineIcons.search, 'step': 4},
    ];

    // Sort the due dates in descending order
    dueDates.sort((a, b) => (b['date'] ?? '').compareTo(a['date'] ?? ''));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Due Dates', style: Theme.of(context).textTheme.titleLarge),
                ...dueDates.map((dueDate) => _buildTimelineItem(context, dueDate['label'], dueDate['date'], dueDate['icon'], dueDate['step'])).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String label, dynamic date, IconData icon, int step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  'Step $step: $label',
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
