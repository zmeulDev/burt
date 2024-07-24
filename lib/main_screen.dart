import 'package:burt/car_screens/car_add_screen.dart';
import 'package:burt/car_screens/car_details_screen.dart';
import 'package:burt/expense_screens/expense_add_screen.dart';
import 'package:burt/expense_screens/expense_details_screen.dart';
import 'package:burt/expense_screens/expenses_view_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'car_screens/cars_view_screen.dart';
import 'auth_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Burt - Car Manager'),
        actions: _selectedIndex == 2
            ? [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authService.signOut();
            },
          )
        ]
            : null,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomeScreen(),
          CarsViewScreen(
            onCarSelected: (carId) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailsScreen(carId: carId),
                ),
              );
            },
            onAddCar: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarAddScreen(),
                ),
              );
            },
          ),
          ExpensesViewScreen(
            onExpenseSelected: (expenseId) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseDetailsScreen(expenseId: expenseId),
                ),
              );
            },
            onAddExpense: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseAddScreen(),
                ),
              );
            },
          ),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        showUnselectedLabels: true,
      ),
    );
  }
}
