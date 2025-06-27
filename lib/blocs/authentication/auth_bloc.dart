import 'dart:developer';

import 'package:driver/api/api_exception.dart';
import 'package:driver/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitialState()) {
    on<CheckboxToggled>((event, emit) {
      try {
        emit(AuthLoadingState());

        emit(RememberChecked(isRememberMeChecked: event.isChecked));
        emit(AuthSucessState(message: "Sucess"));
      } catch (e) {
        log("$e");
        emit(AuthErrorState(message: "$e"));
      }
    });
    on<CheckTerms>((event, emit) {
      log("Checkbox updated: ${event.isTermChecked}");
      emit(TermsChecked(isTermsChecked: event.isTermChecked));
    });
    on<SignUpEvent>((event, emit) {
      try {
        final response = authRepository.SignUpUser(
          fullName: event.fullName,
          contactNumber: event.contactNumber,
          email: event.email,
          password: event.password,
          role: event.role,
          drivingPermitNumber:event.drivingPerminNumber,
          certificateNumber:event.certificateNumber,
        );
        emit(AuthSucessState(message: response[''] ?? ""),
      } on BadRequestException catch (e) {
        AuthErrorState(message: e.message);
      } catch (e) {}
    });
  }
}
