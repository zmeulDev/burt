import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, Map<String, dynamic>>> fetchUpcomingDates() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('cars').get();
  Map<String, Map<String, dynamic>> upcomingEvents = {
    'Insurance': {},
    'Inspection': {},
    'Tax': {},
    'Revision': {},
  };

  for (var doc in snapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;

    DateTime? insuranceDate = DateTime.tryParse(data['nextInsuranceDate']);
    DateTime? inspectionDate = DateTime.tryParse(data['nextInspectionDate']);
    DateTime? taxDate = DateTime.tryParse(data['nextTaxDate']);
    DateTime? revisionDate = DateTime.tryParse(data['nextRevisionDate']);

    if (insuranceDate != null && (upcomingEvents['Insurance']!.isEmpty || insuranceDate.isBefore(upcomingEvents['Insurance']!['date']))) {
      upcomingEvents['Insurance'] = {
        'carId': doc.id,
        'car': data['model'],
        'date': insuranceDate,
      };
    }

    if (inspectionDate != null && (upcomingEvents['Inspection']!.isEmpty || inspectionDate.isBefore(upcomingEvents['Inspection']!['date']))) {
      upcomingEvents['Inspection'] = {
        'carId': doc.id,
        'car': data['model'],
        'date': inspectionDate,
      };
    }

    if (taxDate != null && (upcomingEvents['Tax']!.isEmpty || taxDate.isBefore(upcomingEvents['Tax']!['date']))) {
      upcomingEvents['Tax'] = {
        'carId': doc.id,
        'car': data['model'],
        'date': taxDate,
      };
    }

    if (revisionDate != null && (upcomingEvents['Revision']!.isEmpty || revisionDate.isBefore(upcomingEvents['Revision']!['date']))) {
      upcomingEvents['Revision'] = {
        'carId': doc.id,
        'car': data['model'],
        'date': revisionDate,
      };
    }
  }

  return upcomingEvents;
}
