import 'dart:developer';
import 'package:driver/blocs/location/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../repositories/CurrentLocationRepository.dart';
import '../../repositories/location_repository.dart';
import 'event.dart';


class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationRepository locationRepository;
  CurrentLocationRepository currentLocationRepository;
  LocationBloc(this.locationRepository, this.currentLocationRepository) : super(LocationInitialState()) {
    on<RequestEnableLocation>((event, emit) async {
      log("RequestEnableLocation Triggered");
      emit(LocationLoading());
      try {
        // Fetch permission + location in one call
        final (lat, long, locationName) =
        await currentLocationRepository.getCurrentLocation();
        emit(LocationLoadedState(lat: lat, long: long, location: locationName));
        // Optionally update the location on server
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

    on<FetchLocation>((event, emit) async {
      emit(LocationLoading());
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        final place = placemarks.first;
        final locationName = "${place.locality}, ${place.administrativeArea}, ${place.country}";

        emit(LocationLoadedState(
          lat: position.latitude,
          long: position.longitude, location:locationName,
        ));
        log(position.longitude.toString());
        // emit(LocationSucessState(message: "Location is fetched"));
      } catch (e) {
        log("Error: $e");
        emit(LocationErrorState(message: e.toString()));
      }
    });
  }
}
