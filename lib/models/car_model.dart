import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  String id;
  String maker;
  String model;
  int year;
  String carPlate;
  String vinNumber;
  int engineSize;
  int enginePower;
  String color;
  String fuelType;
  String transmission;
  String tireSize;
  String wiperSize;
  String lightsType;
  bool status;

  Car({
    required this.id,
    required this.maker,
    required this.model,
    required this.year,
    required this.carPlate,
    required this.vinNumber,
    required this.engineSize,
    required this.enginePower,
    required this.color,
    required this.fuelType,
    required this.transmission,
    required this.tireSize,
    required this.wiperSize,
    required this.lightsType,
    required this.status,
  });

  factory Car.fromDocument(DocumentSnapshot doc) {
    return Car(
      id: doc.id,
      maker: doc['maker'] ?? 'N/A',
      model: doc['model'],
      year: doc['year'] ?? 1886,
      carPlate: doc['carPlate'],
      vinNumber: doc['vinNumber'] ?? 'N/A',
      engineSize: doc['engineSize'] ?? 954,
      enginePower: doc['enginePower'] ?? 1,
      color: doc['color'] ?? 'N/A',
      fuelType: doc['fuelType'] ?? 'N/A',
      transmission: doc['transmission'] ?? 'N/A',
      tireSize: doc['tireSize'] ?? 'N/A',
      wiperSize: doc['wiperSize'] ?? 'N/A',
      lightsType: doc['lightsType'] ?? 'N/A',
      status: doc['status'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maker': maker.isNotEmpty ? maker : 'N/A',
      'model': model,
      'year': year,
      'carPlate': carPlate,
      'vinNumber': vinNumber.isNotEmpty ? vinNumber : 'N/A',
      'engineSize': engineSize,
      'enginePower': enginePower,
      'color': color.isNotEmpty ? color : 'N/A',
      'fuelType': fuelType.isNotEmpty ? fuelType : 'N/A',
      'transmission': transmission.isNotEmpty ? transmission : 'N/A',
      'tireSize': tireSize.isNotEmpty ? tireSize : 'N/A',
      'wiperSize': wiperSize.isNotEmpty ? wiperSize : 'N/A',
      'lightsType': lightsType.isNotEmpty ? lightsType : 'N/A',
      'status': status,
    };
  }
}
