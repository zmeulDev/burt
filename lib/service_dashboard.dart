import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'styles.dart';

class ServiceDashboard extends StatelessWidget {
  const ServiceDashboard({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    QuerySnapshot carsSnapshot = await FirebaseFirestore.instance.collection('cars').get();
    List<QueryDocumentSnapshot> allServices = [];
    int totalCars = carsSnapshot.docs.length;

    for (var car in carsSnapshot.docs) {
      QuerySnapshot servicesSnapshot = await car.reference.collection('services').get();
      allServices.addAll(servicesSnapshot.docs);
    }

    double totalCost = allServices.fold(0.0, (sum, service) {
      var cost = service.get('cost');
      return sum + (cost ?? 0.0);
    });

    return {
      'totalCars': totalCars,
      'totalServices': allServices.length,
      'totalCost': totalCost,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchDashboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingPlaceholder();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return _buildNoDataPlaceholder();
        }

        int totalCars = snapshot.data!['totalCars'];
        int totalServices = snapshot.data!['totalServices'];
        double totalCost = snapshot.data!['totalCost'];

        return _buildServiceDashboard(context, totalCars, totalServices, totalCost);
      },
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDashboardCard('Loading...', 'Cars', isLoading: true),
        _buildDashboardCard('Loading...', 'Services', isLoading: true),
        _buildDashboardCard('Loading...', 'Service Cost', isLoading: true),
      ],
    );
  }

  Widget _buildNoDataPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDashboardCard('0', 'Cars'),
        _buildDashboardCard('0', 'Services'),
        _buildDashboardCard('\$0.00', 'Service Cost'),
      ],
    );
  }

  Widget _buildServiceDashboard(BuildContext context, int totalCars, int totalServices, double totalCost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDashboardCard(totalCars.toString(), 'Cars'),
        _buildSeparator(),
        _buildDashboardCard(totalServices.toString(), 'Services'),
        _buildSeparator(),
        _buildDashboardCard('\$${totalCost.toStringAsFixed(2)}', 'Service Cost'),
      ],
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildDashboardCard(String number, String label, {bool isLoading = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isLoading
            ? CircularProgressIndicator()
            : Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
