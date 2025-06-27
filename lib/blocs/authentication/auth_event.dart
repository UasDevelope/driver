import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthEvents extends Equatable {
  const AuthEvents();
  List<Object> get props => [];
}

class CheckboxToggled extends AuthEvents {
  final bool isChecked;
  CheckboxToggled({required this.isChecked});
  List<Object> get props => [isChecked];
}

class CheckTerms extends AuthEvents {
  final bool isTermChecked;
  CheckTerms({required this.isTermChecked});
  List<Object> get props => [isTermChecked];
}

class SignUpEvent extends AuthEvents {
  final String fullName;
  final String email;
  final String password;
  final String contactNumber;
  final String role;
  final String? drivingPerminNumber;
  final String? certificateNumber;
  const SignUpEvent({
    required this.certificateNumber,
    required this.role,
    required this.email,
    required this.password,
    required this.contactNumber,
    required this.fullName,
    required this.drivingPerminNumber,
  });
}
