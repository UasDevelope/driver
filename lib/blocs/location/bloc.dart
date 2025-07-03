import 'dart:developer';
import 'package:driver/blocs/location/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/CurrentLocationRepository.dart';
import '../../repositories/location_repository.dart';
import 'event.dart';


class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationRepository locationRepository;
  CurrentLocationRepository currentLocationRepository;
  LocationBloc(this.locationRepository, this.currentLocationRepository)
      : super(LocationInitialState()) {
    on<RequestEnableLocation>((event, emit) async {
      log("RequestEnableLocation Triggered");
      emit(LocationLoading());
      try {
        final (lat, long, locationName) =
        await currentLocationRepository.getCurrentLocation();
        emit(LocationLoadedState(lat: lat, long: long, location: locationName));
        try {
          final response = await locationRepository.updateLocation(
            latitude: lat,
            longitude: long,
            locationName: locationName,
          );
          emit(LocationSucessState(message: response["message"]));
        } catch (e) {
          emit(LocationErrorState(message: e.toString()));
        }
        log("Location fetched successfully: $lat, $long");
      } catch (e) {
        log("Location fetch failed: $e");
        emit(LocationErrorState(message: e.toString()));
      }
    });
  }
}
