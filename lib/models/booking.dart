class BookingModel {
  final String bookingId;
  final String customerName;
  final int hours;
  final String date;
  final String time;
  final double price;
  final Location location;
  final String locationName;
  final String? assignedDriver;
  final String? driverPermitNumber;
  final Proposal? myProposal;

  BookingModel({
    required this.bookingId,
    required this.customerName,
    required this.hours,
    required this.date,
    required this.time,
    required this.price,
    required this.location,
    required this.locationName,
    this.assignedDriver,
    this.driverPermitNumber,
    this.myProposal,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'],
      customerName: json['customerName'],
      hours: json['hours'],
      date: json['date'],
      time: json['time'],
      price: (json['price'] as num).toDouble(),
      location: Location.fromJson(json['location']),
      locationName: json['locationName'],
      assignedDriver: json['assignedDriver'],
      driverPermitNumber: json['driverPermitNumber'],
      myProposal: json['myProposal'] != null
          ? Proposal.fromJson(json['myProposal'])
          : null,
    );
  }
}
class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates:
      List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}
class Proposal {
  final String id;
  final String serviceProviderId;
  final int hours;
  final double price;
  final String date;
  final String time;
  final String specialRequirements;
  final String status;
  final CurrentLocation? currentLocation;
  final String submittedAt;

  Proposal({
    required this.id,
    required this.serviceProviderId,
    required this.hours,
    required this.price,
    required this.date,
    required this.time,
    required this.specialRequirements,
    required this.status,
    required this.submittedAt,
    this.currentLocation,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['_id'],
      serviceProviderId: json['serviceProviderId'],
      hours: json['hours'],
      price: (json['price'] as num).toDouble(),
      date: json['date'],
      time: json['time'],
      specialRequirements: json['specialRequirements'],
      status: json['status'],
      submittedAt: json['submittedAt'],
      currentLocation: json['currentLocation'] != null
          ? CurrentLocation.fromJson(json['currentLocation'])
          : null,
    );
  }
}
class CurrentLocation {
  final String type;
  final List<double> coordinates;
  final String capturedAt;

  CurrentLocation({
    required this.type,
    required this.coordinates,
    required this.capturedAt,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'],
      coordinates:
      List<double>.from(json['coordinates'].map((x) => x.toDouble())),
      capturedAt: json['capturedAt'],
    );
  }
}
