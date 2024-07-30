import 'package:burt/models/car_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'car_edit_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final String carId;

  CarDetailsScreen({required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.model,
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      car.status
                          ? Image.asset(
                              'assets/illustrations/cars_active.png',
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/illustrations/cars_inactive.png',
                              fit: BoxFit.cover,
                            ),
                      Container(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Card(
                              shape: CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Iconsax.edit_copy),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CarEditScreen(carId: car.id),
                                ),
                              );
                            },
                          ),
                          Card(
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Icon(Iconsax.trash_copy),
                                onTap: () async {
                                  await CarService().deleteCar(car.id);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          car.status
                              ? Card(
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Iconsax.like_1_copy,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 24.0),
                                  ),
                                )
                              : Card(
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Iconsax.dislike_copy,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        size: 24.0),
                                  ),
                                )
                        ],
                      ),
                    ),
                    _buildCarInfoSection(context, 'Basic Information', [
                      _buildDetailRow(
                          context, Iconsax.car_copy, 'Maker:', car.maker),
                      _buildDetailRow(context, Iconsax.speedometer_copy,
                          'Model:', car.model),
                      _buildDetailRow(context, Iconsax.record_circle_copy,
                          'Car Plate:', car.carPlate),
                      _buildDetailRow(context, Iconsax.calendar_1_copy, 'Year:',
                          car.year != 0 ? car.year.toString() : 'N/A'),
                    ]),
                    _buildCarInfoSection(context, 'Additional Details', [
                      _buildDetailRow(context, Iconsax.key_copy, 'VIN:',
                          car.vinNumber.isNotEmpty ? car.vinNumber : 'N/A'),
                      _buildDetailRow(context, Iconsax.colorfilter_copy,
                          'Color:', car.color.isNotEmpty ? car.color : 'N/A'),
                      _buildDetailRow(
                          context,
                          Iconsax.tick_circle_copy,
                          'Tire Size:',
                          car.tireSize.isNotEmpty ? car.tireSize : 'N/A'),
                      _buildDetailRow(
                          context,
                          Iconsax.blend_copy,
                          'Wiper Size:',
                          car.wiperSize.isNotEmpty ? car.wiperSize : 'N/A'),
                      _buildDetailRow(context, Iconsax.sun_copy, 'Lights Type:',
                          car.lightsType.isNotEmpty ? car.lightsType : 'N/A'),
                    ]),
                    _buildCarInfoSection(context, 'Engine and Fuel', [
                      _buildDetailRow(
                          context,
                          Iconsax.camera_copy,
                          'Engine Size:',
                          car.engineSize != 0
                              ? car.engineSize.toString()
                              : 'N/A'),
                      _buildDetailRow(
                          context,
                          Iconsax.flash_1_copy,
                          'Engine Power:',
                          car.enginePower != 0
                              ? car.enginePower.toString()
                              : 'N/A'),
                      _buildDetailRow(
                          context,
                          Iconsax.gas_station_copy,
                          'Fuel Type:',
                          car.fuelType.isNotEmpty ? car.fuelType : 'N/A'),
                      _buildDetailRow(
                          context,
                          Iconsax.settings,
                          'Transmission:',
                          car.transmission.isNotEmpty
                              ? car.transmission
                              : 'N/A'),
                    ]),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCarInfoSection(
      BuildContext context, String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
