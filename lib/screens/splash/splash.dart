import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/splash/splash_bloc.dart';
import '../../blocs/splash/splash_state.dart';
import '../../core/app_routes.dart';
import '../../utils/const/app_img.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToHome) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if(state is SplashNavigateToLogin){
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(AppImages.logo, height: 300, width: 300),
        ),
      ),
    );
  }
}
