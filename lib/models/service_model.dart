class Service {
  final String id;
  final String carId;
  final String serviceName;
  final String date;
  final double cost;
  final String note;

  Service({
    required this.id,
    required this.carId,
    required this.serviceName,
    required this.date,
    required this.cost,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'carId': carId,
      'serviceName': serviceName,
      'date': date,
      'cost': cost,
      'note': note,
    };
  }

  static Service fromMap(String id, Map<String, dynamic> map) {
    return Service(
      id: id,
      carId: map['carId'],
      serviceName: map['serviceName'],
      date: map['date'],
      cost: map['cost'],
      note: map['note'],
    );
  }
}
