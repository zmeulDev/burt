import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_edit_screen.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final String expenseId;

  ExpenseDetailsScreen({required this.expenseId});

  @override
  Widget build(BuildContext context) {
    final carService = Provider.of<CarService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
      ),
      body: StreamBuilder<Expense>(
        stream: ExpenseService().getExpenseStreamById(expenseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Expense not found'));
          }

          final expense = snapshot.data!;

          return FutureBuilder<Car?>(
            future: carService.getCarById(expense.carId),
            builder: (context, carSnapshot) {
              if (carSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final car = carSnapshot.data;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Car Plate: ${car?.carPlate ?? 'Unknown'}', style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            Text('Type: ${expense.type}', style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            Text('Date: ${expense.date.toLocal()}', style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            Text('Cost: \$${expense.cost.toString()}', style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            if (expense.details['notes'] != null)
                              Text('Notes: ${expense.details['notes']}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExpenseEditScreen(expenseId: expense.id),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                          label: Text('Edit'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await ExpenseService().deleteExpense(expense.id);
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

