import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import 'cars_view_header.dart';

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
                      SvgPicture.asset(
                        'assets/illustrations/no_cars.svg',
                        height: 200,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No cars found',
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
                        return GestureDetector(
                          onTap: () => onCarSelected(car.id),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20.0)),
                                        child: SvgPicture.asset(
                                          car.status
                                              ? 'assets/illustrations/cars_active.svg'
                                              : 'assets/illustrations/cars_inactive.svg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8.0,
                                      right: 8.0,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          car.status
                                              ? Iconsax.tick_circle
                                              : Iconsax.close_circle,
                                          color: car.status
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        car.model,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Plate: ${car.carPlate}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        car.status ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: car.status
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ),
                                            onPressed: () =>
                                                onCarSelected(car.id),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
