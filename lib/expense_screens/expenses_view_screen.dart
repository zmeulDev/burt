import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/services/expense_service.dart';
import 'package:burt/widgets/expenses_view_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesViewScreen extends StatelessWidget {
  final Function(String) onExpenseSelected;
  final VoidCallback onAddExpense;

  ExpensesViewScreen(
      {required this.onExpenseSelected, required this.onAddExpense});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final carService = Provider.of<CarService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("my expenses"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              onAddExpense();
            },
            tooltip: 'Add Expense',
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: authService.user,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Center(child: Text('No user logged in'));
          }

          final userId = userSnapshot.data!.uid;

          return StreamBuilder<List<Expense>>(
            stream: ExpenseService().getExpensesByUser(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/illustrations/other.png',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No expenses found',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: onAddExpense,
                        child: Text('Add an Expense'),
                      ),
                    ],
                  ),
                );
              }

              final expenses = snapshot.data!;
              return ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return FutureBuilder<Car?>(
                    future: carService.getCarById(expense.carId),
                    builder: (context, carSnapshot) {
                      if (carSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final car = carSnapshot.data;
                      return ExpensesViewCard(
                        expense: expense,
                        car: car,
                        onExpenseSelected: onExpenseSelected,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
