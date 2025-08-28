import 'dart:developer';
import 'package:driver/api/api_exception.dart';
import 'package:driver/models/auth_model.dart';
import 'package:driver/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/local.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitialState()) {
    on<CheckboxToggled>((event, emit) {
      log("checkBox: ${event.isChecked}");
      emit(RememberChecked(isRememberMeChecked: event.isChecked));
    });
    on<SignUpEvent>(signUp);
    on<LoginRequest>(logIn);


  }
  void signUp(SignUpEvent event, Emitter<AuthState> emit)async {
    emit(AuthLoadingState());
    try {
      final AuthModel authModel = event.authModel;
      log("Calling API with: ${authModel.toJson()}");
      final response = await authRepository.signUpUser(authModel: authModel);
      log("Response here: $response");
      final token = response["token"];
      final message = response["message"] ?? "Signup successful";
      
      if (token != null && token is String && token.isNotEmpty) {
        await LocalStorage.storeString(LocalStorage.AcessToken, token);
        final storedToken = await LocalStorage.getString(LocalStorage.AcessToken);
        log("Token stored: $storedToken");
        emit(AuthSuccessState(message: message));
      } else {
        log("Token missing in response: $response");
        // If no token is present, treat as error
        final errorMessage = response["message"] ?? "Signup failed. Please try again.";
        emit(AuthErrorState(message: errorMessage));
      }

    } on BadRequestException catch (e) {
      log("BadRequestException: ${e.message}");
      emit(AuthErrorState(message: e.message));
    } catch (e, stack) {
      log("Unexpected Error: $e\n$stack");
      emit(AuthErrorState(message: "An unexpected error occurred"));
    }
  }

  void logIn(LoginRequest event, Emitter<AuthState> emit)async {
    emit(AuthLoadingState());
    try {
      var response = await authRepository.loginUser(
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
  }
}
