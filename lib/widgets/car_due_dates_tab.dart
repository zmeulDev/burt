import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DueDatesTab extends StatelessWidget {
  final Map<String, dynamic> carData;

  DueDatesTab({required this.carData});

  @override
  Widget build(BuildContext context) {
    // Create a list of due dates
    List<Map<String, dynamic>> dueDates = [
      {'label': 'Next Tax Due', 'date': carData['taxDue'], 'icon': LineIcons.moneyBill},
      {'label': 'Next Insurance Due', 'date': carData['insuranceDue'], 'icon': LineIcons.userShield},
      {'label': 'Next Service Due', 'date': carData['serviceDue'], 'icon': LineIcons.tools},
      {'label': 'Next Inspection Due', 'date': carData['inspectionDue'], 'icon': LineIcons.search},
    ];

    // Sort the due dates in descending order
    dueDates.sort((a, b) => (b['date'] ?? '').compareTo(a['date'] ?? ''));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Due Dates', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2, // Adjust this value to make the grid items taller
              ),
              itemCount: dueDates.length,
              itemBuilder: (context, index) {
                final dueDate = dueDates[index];
                return _buildGridItem(context, dueDate['label'], dueDate['date'], dueDate['icon']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String label, dynamic date, IconData icon) {
    bool isFutureDate = false;
    if (date != null) {
      final parsedDate = DateTime.tryParse(date);
      if (parsedDate != null) {
        isFutureDate = parsedDate.isAfter(DateTime.now());
      }
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isFutureDate ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.5) : Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
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
