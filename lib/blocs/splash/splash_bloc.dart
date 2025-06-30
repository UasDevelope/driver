import 'package:driver/blocs/splash/splash_event.dart';
import 'package:driver/blocs/splash/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/local.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitialState()) {
    on<checkAuthenticationStatus>(_onSplashLoaded);
  }
  Future<void> _onSplashLoaded(
    checkAuthenticationStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoadingState());
    try {
      await Future.delayed(Duration(seconds: 3));
      final bool hasToken = await _hasToken();
      print("Has token :$hasToken");
      if (hasToken) {
        emit(SplashNavigateToHome());
      } else {
        emit(SplashNavigateToLogin());
      }
    } catch (e) {
      // Optionally handle error
      emit(SplashNavigateToLogin());
    }
  }

  Future<bool> _hasToken() async {
    final token = await LocalStorage.getString(LocalStorage.AcessToken);
    print("Token here : $token");
    return token != null && token.isNotEmpty;
  }

}
