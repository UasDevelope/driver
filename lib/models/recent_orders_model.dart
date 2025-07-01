class RecentOrdersModel {
  final bool? success;
  final String? message;
  final int? count;
  final List<Booking>? bookings;

  RecentOrdersModel({
    this.success,
    this.message,
    this.count,
    this.bookings,
  });

  factory RecentOrdersModel.fromJson(Map<String, dynamic> json) {
    return RecentOrdersModel(
      success: json['success'],
      message: json['message'],
      count: json['count'],
      bookings: (json['bookings'] as List?)
          ?.map((x) => Booking.fromJson(x))
          .toList(),
    );
  }
}

class Booking {
  final String? id;
  final User? userId;
  final ServiceProvider? serviceProviderId;
  final int? hours;
  final DateTime? date;
  final int? price;
  final String? specialRequirements;
  final String? status;
  final Location? location;
  final String? locationName;
  final List<Proposal>? proposals;
  final String? acceptedProposalId;
  final List<String>? messages;
  final DateTime? createdAt;
  final String? formattedDate;
  final String? formattedTime;
  final String? formattedCreatedAt;

  Booking({
    this.id,
    this.userId,
    this.serviceProviderId,
    this.hours,
    this.date,
    this.price,
    this.specialRequirements,
    this.status,
    this.location,
    this.locationName,
    this.proposals,
    this.acceptedProposalId,
    this.messages,
    this.createdAt,
    this.formattedDate,
    this.formattedTime,
    this.formattedCreatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      userId: json['userId'] != null ? User.fromJson(json['userId']) : null,
      serviceProviderId: json['serviceProviderId'] != null
          ? ServiceProvider.fromJson(json['serviceProviderId'])
          : null,
      hours: json['hours'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      price: json['price'],
      specialRequirements: json['specialRequirements'],
      status: json['status'],
      location:
      json['location'] != null ? Location.fromJson(json['location']) : null,
      locationName: json['locationName'],
      proposals: (json['proposals'] as List?)
          ?.map((x) => Proposal.fromJson(x))
          .toList(),
      acceptedProposalId: json['acceptedProposalId'],
      messages:
      (json['messages'] as List?)?.map((x) => x.toString()).toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      formattedDate: json['formattedDate'],
      formattedTime: json['formattedTime'],
      formattedCreatedAt: json['formattedCreatedAt'],
    );
  }
}

class User {
  final String? id;
  final String? fullName;
  final String? contactNumber;
  final String? email;

  User({
    this.id,
    this.fullName,
    this.contactNumber,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['fullName'],
      contactNumber: json['contactNumber'],
      email: json['email'],
    );
  }
}

class ServiceProvider {
  final String? id;
  final String? fullName;
  final String? contactNumber;
  final String? drivingPermitNumber;
  final String? certificateNumber;

  ServiceProvider({
    this.id,
    this.fullName,
    this.contactNumber,
    this.drivingPermitNumber,
    this.certificateNumber,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['_id'],
      fullName: json['fullName'],
      contactNumber: json['contactNumber'],
      drivingPermitNumber: json['drivingPermitNumber'],
      certificateNumber: json['certificateNumber'],
    );
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: (json['coordinates'] as List?)
          ?.map((x) => (x as num).toDouble())
          .toList(),
    );
  }
}

class Proposal {
  final String? serviceProviderId;
  final int? hours;
  final int? price;
  final DateTime? date;
  final String? time;
  final String? specialRequirements;
  final DateTime? submittedAt;

  Proposal({
    this.serviceProviderId,
    this.hours,
    this.price,
    this.date,
    this.time,
    this.specialRequirements,
    this.submittedAt,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      serviceProviderId: json['serviceProviderId'],
      hours: json['hours'],
      price: json['price'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time'],
      specialRequirements: json['specialRequirements'],
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'])
          : null,
    );
  }
}
