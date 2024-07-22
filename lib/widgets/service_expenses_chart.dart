import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ServiceExpensesDoughnutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cars')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, carSnapshot) {
          if (carSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (carSnapshot.hasError) {
            return Center(child: Text('Error: ${carSnapshot.error}'));
          }
          if (!carSnapshot.hasData || carSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No cars found.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          final cars = carSnapshot.data!.docs;
          final carModels = {for (var car in cars) car.id: car['model'] ?? 'Unknown'};

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('services')
                .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, serviceSnapshot) {
              if (serviceSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (serviceSnapshot.hasError) {
                return Center(child: Text('Error: ${serviceSnapshot.error}'));
              }
              if (!serviceSnapshot.hasData || serviceSnapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No service records found.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              final serviceDocs = serviceSnapshot.data!.docs;
              final carExpenses = <String, double>{};

              for (var doc in serviceDocs) {
                final service = doc.data() as Map<String, dynamic>;
                final carId = service['carId'] ?? 'Unknown';
                final carModel = carModels[carId] ?? 'Unknown';
                final cost = double.tryParse(service['cost'].toString()) ?? 0.0;

                if (carExpenses.containsKey(carModel)) {
                  carExpenses[carModel] = carExpenses[carModel]! + cost;
                } else {
                  carExpenses[carModel] = cost;
                }
              }

              final data = carExpenses.entries
                  .map((entry) => DoughnutChartData(carModel: entry.key, cost: entry.value))
                  .toList();

              return SfCircularChart(
                title: ChartTitle(text: 'Service Expenses by Car'),
                legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                series: <CircularSeries>[
                  DoughnutSeries<DoughnutChartData, String>(
                    dataSource: data,
                    xValueMapper: (DoughnutChartData data, _) => data.carModel,
                    yValueMapper: (DoughnutChartData data, _) => data.cost,
                    dataLabelMapper: (DoughnutChartData data, _) => '${data.carModel}: \$${data.cost.toStringAsFixed(2)}',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class DoughnutChartData {
  final String carModel;
  final double cost;

  DoughnutChartData({required this.carModel, required this.cost});
}
