import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


class CarsViewScreen extends StatelessWidget {
  final Function(String) onCarSelected;
  final VoidCallback onAddCar;

  CarsViewScreen({required this.onCarSelected, required this.onAddCar});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              onAddCar();
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
              return ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  final car = cars[index];
                  return GestureDetector(
                    onTap: () => onCarSelected(car.id),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/illustrations/cars_all.svg',
                              height: 90,
                              width: 90,
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  car.model,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: car.status ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.surfaceDim,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Plate: ${car.carPlate}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: car.status ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.surfaceDim,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Status: ${car.status ? 'Active' : 'Inactive'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: car.status ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.surfaceDim,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
