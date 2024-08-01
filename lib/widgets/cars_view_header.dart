import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard(context, Colors.blue, "Total Cars", totalCars),
              _buildStatCard(context, Colors.green, "Active Cars", activeCars),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard(
                  context, Colors.red, "Inactive Cars", inactiveCars),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, Color color, String text, int number) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 12),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
