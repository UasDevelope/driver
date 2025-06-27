import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();
  List<Object> get props => [];
}

class RememberChecked extends AuthState {
  final bool isRememberMeChecked;
  const RememberChecked({required this.isRememberMeChecked});
  List<Object> get props => [isRememberMeChecked];
}

class TermsAndConditionChecked extends AuthState {
  final bool isTermsChecked;
  const TermsAndConditionChecked({required this.isTermsChecked});
  @override
  List<Object> get props => [isTermsChecked];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthLoadedState extends AuthState {
  const AuthLoadedState();
}

class AuthSuccessState extends AuthState {
  final String message;
  const AuthSuccessState({required this.message});
  List<Object> get props => [message];
}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState({required this.message});
}
class SignupState extends AuthState{
 const SignupState();

}