import 'package:burt/car_screens/car_add_screen.dart';
import 'package:burt/car_screens/car_details_screen.dart';
import 'package:burt/expense_screens/expense_add_screen.dart';
import 'package:burt/expense_screens/expense_details_screen.dart';
import 'package:burt/expense_screens/expenses_view_screen.dart';
import 'package:flutter/cupertino.dart';
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
      extendBody: true,
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(top: 0, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_car_outlined),
                label: 'Cars',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_outlined),
                label: 'Expenses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.onPrimary,
            unselectedItemColor: Theme.of(context).colorScheme.onTertiary,
            backgroundColor: Theme.of(context).colorScheme.scrim,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
