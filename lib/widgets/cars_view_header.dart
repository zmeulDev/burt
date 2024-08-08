import 'package:burt/widgets/wave_clipper.dart';
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
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildStatCard(
                context,
                Theme.of(context).colorScheme.tertiaryContainer,
                'Total Cars',
                totalCars,
                Iconsax.gas_station_copy,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildSmallStatCard(
                    context,
                    Theme.of(context).colorScheme.primaryContainer,
                    'Active Cars',
                    activeCars,
                    Icons.check_circle,
                  ),
                  SizedBox(height: 8),
                  _buildSmallStatCard(
                    context,
                    Theme.of(context).colorScheme.errorContainer,
                    'Inactive Cars',
                    inactiveCars,
                    Icons.cancel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, Color color, String text,
      int number, IconData icon) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Icon(icon,
                    color: Theme.of(context).colorScheme.onTertiaryContainer),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '$number',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      ClipPath(
        clipper: WaveClipper(waveDeep: 0, waveDeep2: 40),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.bottomLeft,
        ),
      ),
    ]);
  }

  Widget _buildSmallStatCard(BuildContext context, Color color, String text,
      int number, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                '$number',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddCarCard(
      BuildContext context, Color color, String text, IconData icon) {
    return GestureDetector(
      onTap: onAddCar,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Icon(icon,
                    color: Theme.of(context).colorScheme.onPrimary, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
