import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/widgets/cars_view_card.dart';
import 'package:burt/widgets/cars_view_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class CarsViewScreen extends StatelessWidget {
  final Function(String) onCarSelected;
  final VoidCallback onAddCar;

  CarsViewScreen({required this.onCarSelected, required this.onAddCar});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final carService = CarService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Garage",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(Iconsax.add_square_copy),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: onAddCar,
            tooltip: 'Add Car',
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

          return StreamBuilder<List<Car>>(
            stream: carService.getCarsByUser(userId),
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
                  SliverToBoxAdapter(
                    child: CarsViewHeader(
                      totalCars: totalCars,
                      activeCars: activeCars,
                      inactiveCars: inactiveCars,
                      onAddCar: onAddCar,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final car = cars[index];
                        return FutureBuilder<Map<String, String>>(
                          future: carService.fetchUpcomingTaxForCar(car.id),
                          builder: (context, taxSnapshot) {
                            if (taxSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            final upcomingTax = taxSnapshot.data;

                            return CarsViewCard(
                              model: car.model,
                              carPlate: car.carPlate,
                              status: car.status,
                              carId: car.id,
                              onCarSelected: onCarSelected,
                              upcomingTax: upcomingTax,
                            );
                          },
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
