import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/widgets/cars_view_card.dart';
import 'package:burt/widgets/cars_view_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarsViewScreen extends StatelessWidget {
  final Function(String) onCarSelected;
  final VoidCallback onAddCar;

  CarsViewScreen({required this.onCarSelected, required this.onAddCar});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
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

          return StreamBuilder<List<Car>>(
            stream: CarService().getCarsByUser(userId),
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
                        'You have no cars stored.',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: onAddCar,
                        child: Text('Add a Car'),
                      ),
                    ],
                  ),
                );
              }

              final cars = snapshot.data!;
              final activeCars = cars.where((car) => car.status).length;
              final inactiveCars = cars.length - activeCars;
              final totalCars = cars.length;

              return CustomScrollView(
                slivers: [
                  CarsViewHeader(
                    totalCars: totalCars,
                    activeCars: activeCars,
                    inactiveCars: inactiveCars,
                    onAddCar: onAddCar,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final car = cars[index];
                        return CarsViewCard(
                          model: car.model,
                          carPlate: car.carPlate,
                          status: car.status,
                          carId: car.id,
                          onCarSelected: onCarSelected,
                        );
                      },
                      childCount: cars.length,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
