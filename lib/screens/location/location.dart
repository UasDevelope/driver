import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/location/bloc.dart';
import '../../blocs/location/event.dart';
import '../../blocs/location/state.dart';
import '../../core/app_routes.dart';
import '../../utils/const/app_color.dart';
import '../../utils/const/app_img.dart';
import '../../utils/const/app_string.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_button.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body(context));
  }
  
  Widget _body(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationSucessState) {
          Navigator.pushNamed(context, AppRoutes.home);
        }
      },
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          String? locationText;
          String? buttonText;
          
          if (state is LocationLoadedState) {
            locationText = AppStrings.locationSuccessMessage;
            buttonText = AppStrings.continueButton;
          } else if (state is LocationErrorState) {
            locationText = "Error: ${state.message}";
            buttonText = AppStrings.nextButton;
          } else if (state is LocationPermissionDenied) {
            locationText = AppStrings.locationPermissionMessage;
            buttonText = AppStrings.nextButton;
          } else {
            locationText = AppStrings.enableLocationSubtitle;
            buttonText = AppStrings.nextButton;
          }
          
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Location icon with better styling
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.appColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      AppImages.location, 
                      height: 120, 
                      width: 120,
                    ),
                  ),
                  SizedBox(height: 40),
                  AppText(
                    text: AppStrings.enableLocationTitle,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColor.black,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  AppText(
                    text: locationText,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.grey,
                  ),
                  SizedBox(height: 90),
                  AppButton(
                    backgroundColor: AppColor.appColor,
                    borderRadius: 12,
                    text: buttonText,
                    onPressed: () {
                      if (state is LocationLoadedState) {
                        // If location is loaded, navigate to home
                        Navigator.pushNamed(context, AppRoutes.home);
                      } else {
                        // Request location permission
                        context.read<LocationBloc>().add(RequestEnableLocation());
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
