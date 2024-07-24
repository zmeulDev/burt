import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  String userId;
  String carId;
  String type;
  DateTime date;
  int cost;
  Map<String, dynamic> details;

  Expense({
    required this.id,
    required this.userId,
    required this.carId,
    required this.type,
    required this.date,
    required this.cost,
    required this.details,
  });

  factory Expense.fromDocument(DocumentSnapshot doc) {
    return Expense(
      id: doc.id,
      userId: doc['userId'],
      carId: doc['carId'],
      type: doc['type'],
      date: (doc['date'] as Timestamp).toDate(),
      cost: doc['cost'],
      details: Map<String, dynamic>.from(doc['details']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'carId': carId,
      'type': type,
      'date': date,
      'cost': cost,
      'details': details,
    };
  }
}
