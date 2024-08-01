import 'package:burt/expense_screens/expense_edit_screen.dart';
import 'package:burt/home_screen.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDetailsCard extends StatelessWidget {
  final Expense expense;
  final Car? car;

  const ExpenseDetailsCard({required this.expense, this.car, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(expense.date);

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Plate: ${car?.carPlate ?? 'Unknown'}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Type: ${expense.type}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: _getColorForExpenseType(context, expense.type),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Theme.of(context).colorScheme.outline),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registered:',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$formattedDate',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cost:',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\$${expense.cost.toString()}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Theme.of(context).colorScheme.outline),
          SizedBox(height: 10),
          if (expense.details.isNotEmpty)
            ...expense.details.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_formatDetailKey(entry.key)}:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${entry.value}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            }).toList(),
          Divider(color: Theme.of(context).colorScheme.outline),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ExpenseEditScreen(expenseId: expense.id),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
                label: Text('Edit'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await ExpenseService().deleteExpense(expense.id);
                  if (context.mounted) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                label: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDetailKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .capitalize();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

Color _getColorForExpenseType(BuildContext context, String type) {
  switch (type) {
    case 'Tax':
      return Theme.of(context).colorScheme.errorContainer;
    case 'Service':
      return Theme.of(context).colorScheme.primaryContainer;
    case 'Other':
      return Theme.of(context).colorScheme.tertiaryContainer;
    default:
      return Theme.of(context).colorScheme.primaryContainer;
  }
}
