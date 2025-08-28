class OrdersModel {
  final String? customerName;
  final String? bookingId;
  final int? hours;
  final String? assignedDriver;
  final String? driverPermitNumber;
  final DateTime? date;
  final String? time;
  final int? price;
  final String? locationName;
  final double? latitude;
  final double? longitude;
  final String? status;

  OrdersModel({
    this.customerName,
    this.bookingId,
    this.hours,
    this.assignedDriver,
    this.driverPermitNumber,
    this.date,
    this.time,
    this.price,
    this.locationName,
    this.latitude,
    this.longitude,
    this.status,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    final coordinates = json['location']?['coordinates'];
    // Get status from myProposal.status if available, otherwise from direct status field
    final String? status = json['myProposal']?['status'] ?? json['status'];
    
    return OrdersModel(
      customerName: json['customerName'],
      bookingId: json['bookingId'],
      hours: json['hours'],
      assignedDriver: json['assignedDriver'],
      driverPermitNumber: json['driverPermitNumber'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time'],
      price: json['price'],
      locationName: json['locationName'],
      longitude: (coordinates != null && coordinates.length > 0) ? coordinates[0].toDouble() : null,
      latitude: (coordinates != null && coordinates.length > 1) ? coordinates[1].toDouble() : null,
      status: status,
    );
  }
}
