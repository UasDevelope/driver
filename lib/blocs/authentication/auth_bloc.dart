import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
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
  }
}
