import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/auth_bloc.dart';
import '../blocs/location/bloc.dart';
import '../blocs/location/event.dart';
import '../blocs/splash/splash_bloc.dart';
import '../blocs/splash/splash_event.dart';

List<BlocProvider> getAppBlocProvider() {
  return [
    BlocProvider<SplashBloc>(
      create: (context) => SplashBloc()..add(checkAuthenticationStatus()),
    ),
    BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
    BlocProvider<LocationBloc>(
      create: (_) => LocationBloc()..add(RequestEnableLocation()),
    ),
  ];
}
