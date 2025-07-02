import 'package:driver/models/home.dart';
import 'package:driver/models/order.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeLoadedState extends HomeState {
  final List<OrdersModel> ordersModel;
  final Set<Polyline> polyLines; // <- update this line
  final Set<Marker> marker;
  final CameraPosition cameraPosition;
  const HomeLoadedState({
    required this.ordersModel,
    required this.cameraPosition,
    required this.polyLines,
    required this.marker,
  });
  @override
  List<Object> get props => [ordersModel,polyLines,cameraPosition,marker];
}
class LocationLoadingState extends HomeState {
  const LocationLoadingState();
}

class LocationLoaded extends HomeState {
  final String city;
  final String country;
  final String address;

  const LocationLoaded({
    required this.city,
    required this.country,
    required this.address,
  });
  @override
  List<Object> get props => [city,country,address];
}
class LocationError extends HomeState {
  final String message;

  const LocationError(this.message);
  @override
  List<Object> get props => [message];
}
