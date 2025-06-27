import 'package:driver/models/auth_model.dart';
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
  @override
  List<Object> get props => [isChecked];
}

class CheckTermsAndConditions extends AuthEvents {
  final bool isTermChecked;
  CheckTermsAndConditions({required this.isTermChecked});
  @override
  List<Object> get props => [isTermChecked];
}

class SignUpEvent extends AuthEvents {
  AuthModel authModel;
  SignUpEvent({required this.authModel});
}
class LoginRequest extends AuthEvents {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});
  List<Object> get props => [email, password];
}
