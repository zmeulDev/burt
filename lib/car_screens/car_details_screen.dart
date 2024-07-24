import 'package:burt/models/car_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:flutter/material.dart';
import 'car_edit_screen.dart';


class CarDetailsScreen extends StatelessWidget {
  final String carId;

  CarDetailsScreen({required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: StreamBuilder<Car>(
        stream: CarService().getCarStreamById(carId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Car not found'));
          }

          final car = snapshot.data!;

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
                        Text(
                          'Maker: ${car.maker}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Model: ${car.model}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Year: ${car.year != 0 ? car.year.toString() : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Car Plate: ${car.carPlate}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'VIN: ${car.vinNumber.isNotEmpty ? car.vinNumber : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Engine Size: ${car.engineSize != 0 ? car.engineSize.toString() : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Engine Power: ${car.enginePower != 0 ? car.enginePower.toString() : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Color: ${car.color.isNotEmpty ? car.color : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fuel Type: ${car.fuelType.isNotEmpty ? car.fuelType : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Transmission: ${car.transmission.isNotEmpty ? car.transmission : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tire Size: ${car.tireSize.isNotEmpty ? car.tireSize : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Wiper Size: ${car.wiperSize.isNotEmpty ? car.wiperSize : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lights Type: ${car.lightsType.isNotEmpty ? car.lightsType : 'N/A'}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Status: ${car.status ? 'Active' : 'Not Active'}',
                          style: TextStyle(fontSize: 18),
                        ),
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
                            builder: (context) => CarEditScreen(carId: car.id),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Edit'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await CarService().deleteCar(car.id);
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
      ),
    );
  }
}


