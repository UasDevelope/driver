import 'package:driver/blocs/home/bloc.dart';
import 'package:driver/blocs/home/event.dart';
import 'package:driver/blocs/order/bloc.dart';
import 'package:driver/blocs/order/event.dart';
import 'package:driver/blocs/propsal/propsal_bloc.dart';
import 'package:driver/repositories/CurrentLocationRepository.dart';
import 'package:driver/repositories/auth_repository.dart';
import 'package:driver/repositories/location_repository.dart';
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
    BlocProvider<ProposalBloc>(
      create: (context) => ProposalBloc()),
    BlocProvider<AuthBloc>(create: (_) => AuthBloc(authRepository: AuthRepository())),
    BlocProvider<LocationBloc>(
      create: (_) => LocationBloc(LocationRepository(),CurrentLocationRepository())..add(RequestEnableLocation()),
    ),
    BlocProvider<HomeBloc>(create: (_) => HomeBloc()..add(HomeLoadedEvent())),
    BlocProvider<ChatUserBloc>(
      create: (_) => ChatUserBloc()..add(ChatUserLoadedEvent()),
    ),
    BlocProvider<ChatInboxBloc>(
      create: (_) => ChatInboxBloc()..add(ChatLoadedEvent()),
    ),
    BlocProvider<OrderBloc>(
      create: (_) => OrderBloc()..add(OrderLoadedEvent()),
    ),
  ];
}
