import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driver/blocs/profile/profile_event.dart';
import 'package:driver/blocs/profile/profile_state.dart';
import 'package:driver/models/profile_model.dart';
import 'package:driver/repositories/profile_repository.dart';
import '../../api/api_exception.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository profileRepo = ProfileRepository();
  ProfileBloc() : super(ProfileInitial()) {
    on<GetProfileEvent>(getProfile);
  }

  Future<void> getProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      ProfileModel profile = await profileRepo.getProfile();
      log("[ProfileBloc] Profile fetched: ${profile.satisfaction}");
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      String errorMessage = "Failed to load profile";
      if (e is ApiException) {
        errorMessage = e.message;
        log("API Error: $errorMessage");
      } else {
        log("Unexpected Error: $e");
        errorMessage = e.toString();
      }
      emit(ProfileError(errorMessage));
    }
  }


}
