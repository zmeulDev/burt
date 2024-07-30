import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/services/expense_service.dart';
import 'package:burt/widgets/expense_details_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    ExpenseDetailsCard(
                      expense: expense,
                      car: car,
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
