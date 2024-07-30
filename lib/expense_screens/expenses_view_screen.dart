import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/services/expense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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
            tooltip: 'Log Out',
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
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No expenses found',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 16),
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
                      final formattedDate =
                          DateFormat('yyyy-MM-dd').format(expense.date);

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        child: ListTile(
                          leading: SvgPicture.asset(
                            _getImageForExpenseType(expense.type),
                            width: 90,
                            height: 90,
                          ),
                          title:
                              Text('Car Plate: ${car?.carPlate ?? 'Unknown'}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Type: ${expense.type}'),
                              Text('Date: $formattedDate'),
                              Text('Cost: \$${expense.cost.toString()}'),
                            ],
                          ),
                          onTap: () => onExpenseSelected(expense.id),
                        ),
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

  String _getImageForExpenseType(String type) {
    switch (type) {
      case 'Tax':
        return 'assets/illustrations/tax.svg';
      case 'Service':
        return 'assets/illustrations/service.svg';
      case 'Other':
        return 'assets/illustrations/other.svg';
      default:
        return 'assets/illustrations/default.svg';
    }
  }
}
