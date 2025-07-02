class ProfileModel {
  final bool success;
  final String message;
  final User user;
  final double? rating;
  final String satisfaction;
  final String cancellationRate;
  final List<ReviewModel> reviews;
  final List<String> achievements;

  ProfileModel({
    required this.success,
    required this.message,
    required this.user,
    this.rating,
    required this.satisfaction,
    required this.cancellationRate,
    required this.reviews,
    required this.achievements,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      rating: json['rating'] != null ? (json['rating'] as num?)?.toDouble() : null,
      satisfaction: json['satisfaction'] ?? '',
      cancellationRate: json['cancellationRate'] ?? '',
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  @override
  String toString() {
    return 'ProfileModel(success: $success, message: $message, user: $user, '
        'rating: $rating, satisfaction: $satisfaction, cancellationRate: $cancellationRate, '
        'reviews: $reviews, achievements: $achievements)';
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String contactNumber;
  final String role;
  final String? drivingPermitNumber;
  final String? certificateNumber;
  final String? locationName;
  final bool isLocationEnabled;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;
  final Location? location;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.contactNumber,
    required this.role,
    this.drivingPermitNumber,
    this.certificateNumber,
    this.locationName,
    required this.isLocationEnabled,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      role: json['role'] ?? '',
      drivingPermitNumber: json['drivingPermitNumber'],
      certificateNumber: json['certificateNumber'],
      locationName: json['locationName'],
      isLocationEnabled: json['isLocationEnabled'] ?? false,
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      lastLogin: DateTime.tryParse(json['lastLogin'] ?? ''),
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }

  @override
  String toString() {
    return 'User(fullName: $fullName, email: $email, contact: $contactNumber, '
        'role: $role, locationName: $locationName)';
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
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((x) => (x as num).toDouble())
          .toList(),
    );
  }

  @override
  String toString() => 'Location(type: $type, coordinates: $coordinates)';
}

class ReviewModel {
  final String reviewer;
  final int rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.reviewer,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewer: json['reviewer'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  String toString() => 'Review($reviewer, $rating, $comment, $date)';
}
