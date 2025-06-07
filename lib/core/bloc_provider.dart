import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/authentication/auth_bloc.dart';
import 'package:training_request/blocs/location/bloc.dart';
import 'package:training_request/blocs/location/event.dart';
import 'package:training_request/blocs/nav/bloc.dart';
import 'package:training_request/blocs/splash/splash_event.dart';

import '../blocs/splash/splash_bloc.dart';

List<BlocProvider> getAppBlocProvider() {
  return [
    BlocProvider<SplashBloc>(
      create: (context) => SplashBloc()..add(checkAuthenticationStatus()),
    ),
    BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
    BlocProvider<LocationBloc>(
      create: (_) => LocationBloc()..add(RequestEnableLocation()),
    ),
    BlocProvider<NavBloc>(create: (_)=>NavBloc()),
  ];
}
