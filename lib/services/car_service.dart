import 'package:burt/models/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarService {
  final CollectionReference carCollection =
      FirebaseFirestore.instance.collection('cars');

  Future<void> addCar(Car car, String userId) async {
    await carCollection.add({
      ...car.toMap(),
      'userId': userId,
    });
  }

  Future<void> updateCar(Car car) async {
    await carCollection.doc(car.id).update(car.toMap());
  }

  Future<void> deleteCar(String carId) async {
    await carCollection.doc(carId).delete();
  }

  Stream<List<Car>> getCarsByUser(String userId) {
    return carCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Car.fromDocument(doc)).toList();
    });
  }

  Future<Car?> getCarById(String carId) async {
    final doc = await carCollection.doc(carId).get();
    if (doc.exists) {
      return Car.fromDocument(doc);
    }
    return null;
  }

  Stream<Car> getCarStreamById(String carId) {
    return carCollection
        .doc(carId)
        .snapshots()
        .map((doc) => Car.fromDocument(doc));
  }

  // New method to fetch upcoming tax
  Future<Map<String, String>> fetchUpcomingTaxForCar(String carId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('carId', isEqualTo: carId)
          .where('type', isEqualTo: 'Tax')
          .orderBy('details.taxValidTo', descending: false)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return {
          'taxType': doc['details']['taxType'] as String,
          'taxValidTo': (doc['details']['taxValidTo'] as String),
        };
      }

      return {'taxType': 'None', 'taxValidTo': '1985-05-20'};
    } catch (e) {
      print('Error fetching upcoming tax: $e');
      return {'taxType': 'Error', 'taxValidTo': '1985-05-20'};
    }
  }
}
