import 'dart:developer';
import 'package:driver/api/api_exception.dart';
import 'package:driver/models/auth_model.dart';
import 'package:driver/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitialState()) {
    on<CheckboxToggled>((event, emit) {
      log("checkox: ${event.isChecked}");
      emit(RememberChecked(isRememberMeChecked: event.isChecked));
    });
    on<CheckTermsAndConditions>((event, emit) {
      log("Checkbox updated: ${event.isTermChecked}");
      emit(TermsAndConditionChecked(isTermsChecked: event.isTermChecked));
    });
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        AuthModel authModel = event.authModel;
        final response = await authRepository.SignUpUser(authModel:authModel ) as Map<String, dynamic>;
        emit(AuthSuccessState(message: response['message'] ?? ""));
      } on BadRequestException catch (e) {
        emit(AuthErrorState(message: e.message));
      } catch (e) {
        emit(AuthErrorState(message: "An unexpected error occurred"));
      }
    });
    on<LoginRequest>((event, emit) async {
      emit(AuthLoadingState());
      try {
        var response = await authRepository.LoginUser(
          email: event.email,
          password: event.password,
        );
        emit(
          AuthSuccessState(message: response["message"] ?? "Login successful"),
        );
      } on BadRequestException catch (e) {
        emit(AuthErrorState(message: e.message));
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });
  }

}
