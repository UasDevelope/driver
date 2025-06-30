import 'package:driver/models/base_model.dart';

class BookingModel implements BaseModel {
  final String id;
  final Location location;
  final User user;
  final String? serviceProviderId;
  final int hours;
  final String date;
  final int price;
  final String specialRequirements;
  final String status;
  final String locationName;
  final List<dynamic> proposals;
  final String? acceptedProposalId;
  final List<dynamic> messages;
  final String createdAt;

  BookingModel({
    required this.id,
    required this.location,
    required this.user,
    this.serviceProviderId,
    required this.hours,
    required this.date,
    required this.price,
    required this.specialRequirements,
    required this.status,
    required this.locationName,
    required this.proposals,
    this.acceptedProposalId,
    required this.messages,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'],
      location: Location.fromJson(json['location']),
      user: User.fromJson(json['userId']),
      serviceProviderId: json['serviceProviderId'],
      hours: json['hours'],
      date: json['date'],
      price: json['price'],
      specialRequirements: json['specialRequirements'],
      status: json['status'],
      locationName: json['locationName'],
      proposals: json['proposals'] ?? [],
      acceptedProposalId: json['acceptedProposalId'],
      messages: json['messages'] ?? [],
      createdAt: json['createdAt'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'location': location.toMap(),
      'userId': user.toMap(),
      'serviceProviderId': serviceProviderId,
      'hours': hours,
      'date': date,
      'price': price,
      'specialRequirements': specialRequirements,
      'status': status,
      'locationName': locationName,
      'proposals': proposals,
      'acceptedProposalId': acceptedProposalId,
      'messages': messages,
      'createdAt': createdAt,
    };
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
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
class User {
  final String id;
  final String fullName;
  final String contactNumber;

  User({
    required this.id,
    required this.fullName,
    required this.contactNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'],
      contactNumber: json['contactNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'fullName': fullName,
      'contactNumber': contactNumber,
    };
  }
}
