import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'api/service_locator.dart';
import 'core/app_routes.dart';
import 'core/bloc_provider.dart';
import 'utils/server_health_checker.dart';

void main() async {
  setupLocator();
  
  // Check server health on app startup
  WidgetsFlutterBinding.ensureInitialized();
  await ServerHealthChecker.autoSwitchToBestServer();
  
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getAppBlocProvider(),
      child: MaterialApp(
        initialRoute: AppRoutes.splash,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGenerateRoute,

      ),
    );
  }
}

