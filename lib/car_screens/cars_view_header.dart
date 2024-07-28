import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CarsViewHeader extends StatelessWidget {
  final int totalCars;
  final int activeCars;
  final int inactiveCars;
  final VoidCallback onAddCar;

  CarsViewHeader({
    required this.totalCars,
    required this.activeCars,
    required this.inactiveCars,
    required this.onAddCar,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "Garage",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        background: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Container(
            color: Theme.of(context).colorScheme.outline,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(context, Iconsax.car_copy, "$totalCars"),
                      _buildStatCard(
                          context, Iconsax.tick_circle_copy, "$activeCars"),
                      _buildStatCard(
                          context, Iconsax.close_circle_copy, "$inactiveCars"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Iconsax.add_square_copy),
          onPressed: onAddCar,
          tooltip: 'Add car',
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String count) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: CircleBorder(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              size: 60,
            ),
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
            child: Text(
              count,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
