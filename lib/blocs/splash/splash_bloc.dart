import 'package:driver/blocs/splash/splash_event.dart';
import 'package:driver/blocs/splash/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      if (hasToken) {
        emit(SplashNavigateToLogin());
      } else {
        emit(SplashNavigateToHome());
      }
    } catch (e) {
      // Optionally handle error
      emit(SplashNavigateToLogin());
    }
  }

  Future<bool> _hasToken() async {
    return false;
  }
}
