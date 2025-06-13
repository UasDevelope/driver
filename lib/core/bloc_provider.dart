import 'package:driver/blocs/home/bloc.dart';
import 'package:driver/blocs/home/event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/auth_bloc.dart';
import '../blocs/chat_user/bloc.dart';
import '../blocs/chat_user/event.dart';
import '../blocs/inbox/bloc.dart';
import '../blocs/inbox/event.dart';
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
    BlocProvider<HomeBloc>(create: (_) => HomeBloc()..add(HomeLoadedEvent())),
    BlocProvider<ChatUserBloc>(
      create: (_) => ChatUserBloc()..add(ChatUserLoadedEvent()),
    ),
    BlocProvider<ChatInboxBloc>(
      create: (_) => ChatInboxBloc()..add(ChatLoadedEvent()),
    ),
  ];
}
