import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> calculateTotalServiceEntries() async {
  int totalServiceEntries = 0;
  var carsSnapshot = await FirebaseFirestore.instance.collection('cars').get();
  for (var car in carsSnapshot.docs) {
    var servicesSnapshot = await FirebaseFirestore.instance
        .collection('cars')
        .doc(car.id)
        .collection('services')
        .get();
    totalServiceEntries += servicesSnapshot.size;
  }
  return totalServiceEntries;
}

Future<double> calculateTotalServiceCost() async {
  double totalServiceCost = 0.0;
  var carsSnapshot = await FirebaseFirestore.instance.collection('cars').get();
  for (var car in carsSnapshot.docs) {
    var servicesSnapshot = await FirebaseFirestore.instance
        .collection('cars')
        .doc(car.id)
        .collection('services')
        .get();
    for (var service in servicesSnapshot.docs) {
      var serviceData = service.data() as Map<String, dynamic>;
      totalServiceCost += (serviceData.containsKey('cost') ? serviceData['cost'] as double : 0.0);
    }
  }
  return totalServiceCost;
}
