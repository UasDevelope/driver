class orderModels {
  final String userName;
  final String imageUrl;
  final String bookingId;
  final String assignedDriver;
  final String DrivingPermit;
  final String Location;
  final String date;
  final String time;
  final String payment;
  final String status;
  orderModels({
    required this.userName,
    required this.imageUrl,
    required this.bookingId,
    required this.assignedDriver,
    required this.DrivingPermit,
    required this.Location,
    required this.date,
    required this.time,
    required this.payment,
    required this.status,
  });
  factory orderModels.fromMap(Map<String, dynamic> map) {
    return orderModels(
      userName: map["userName"] ?? '',
      imageUrl: map["imageUrl"] ?? '',
      bookingId: map["bookingId"] ?? '',
      assignedDriver: map["assignedDriver"] ?? '',
      DrivingPermit: map["DrivingPermit"] ?? '',
      Location: map["Location"] ?? '',
      date: map["date"] ?? '',
      time: map["time"] ?? '',
      payment: map["payment"] ?? '',
      status: map["status"] ?? '',
    );
  }
}
class SimpleBooking {
  final String? customerName;
  final String? bookingId;
  final int? hours;
  final String? assignedDriver;
  final String? driverPermitNumber;
  final DateTime? date;
  final String? time;
  final int? price;

  SimpleBooking({
    this.customerName,
    this.bookingId,
    this.hours,
    this.assignedDriver,
    this.driverPermitNumber,
    this.date,
    this.time,
    this.price,
  });

  factory SimpleBooking.fromJson(Map<String, dynamic> json) {
    return SimpleBooking(
      customerName: json['customerName'],
      bookingId: json['bookingId'],
      hours: json['hours'],
      assignedDriver: json['assignedDriver'],
      driverPermitNumber: json['driverPermitNumber'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time'],
      price: json['price'],
    );
  }
}
