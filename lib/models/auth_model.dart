class AuthModel {
  final String fullName;
  final String email;
  final String contactNumber;
  final String password;
  final String role;
  final String? drivingPermitNumber;
  final String? certificateNumber;

  AuthModel({
    required this.fullName,
    required this.email,
    required this.contactNumber,
    required this.password,
    required this.role,
    this.drivingPermitNumber,
    this.certificateNumber,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      fullName: json['fullName'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      password: json['password'],
      role: json['role'],
      drivingPermitNumber: json['drivingPermitNumber'],
      certificateNumber: json['certificateNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'contactNumber': contactNumber,
      'password': password,
      'role': role,
      if (drivingPermitNumber != null) 'drivingPermitNumber': drivingPermitNumber,
      if (certificateNumber != null) 'certificateNumber': certificateNumber,
    };
  }
}
