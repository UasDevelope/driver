import 'dart:developer';
import 'dart:ui';

import 'package:driver/api/api_const.dart';
import 'package:driver/blocs/home/event.dart';
import 'package:driver/blocs/home/state.dart';
import 'package:driver/dummy/home.dart';
import 'package:driver/models/home.dart';
import 'package:driver/utils/const/app_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/order.dart';
import '../../repositories/orders_repository.dart';
import '../location/state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  OrdersRepository ordersRepo = OrdersRepository();
  HomeBloc() : super(HomeInitialState()) {
    on<HomeLoadedEvent>(fetchOrders);
    on<FetchLocationDetailsEvent>(onFetchLocationDetails);
  }
  void fetchOrders(HomeLoadedEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    try {
      List<OrdersModel> orders = await ordersRepo.getBookings(ApiConstants.pendingBookings);

      final Set<Polyline> polyLines = {};
      final Set<Marker> marker = {};
      CameraPosition cameraPosition = const CameraPosition(
        target: LatLng(89.0, 9.0),
        zoom: 10,
      );

      if (orders.isNotEmpty) {
        cameraPosition = CameraPosition(
          target: LatLng(89.0, 89.7),
          zoom: 12,
        );

        for (int i = 0; i < orders.length; i++) {
          final order = orders[i];
          final customerLatLong = LatLng(31.5204, 74.3587);
          final driverLatLng = LatLng(order.latitude!,order.longitude!);

          final studentIcon = await getCustomIcon(AppImages.start);
          final driverIcon = await getCustomIcon(AppImages.end);

          marker.add(
            Marker(
              markerId: MarkerId('student_$i'),
              position: customerLatLong,
              icon: studentIcon,
              infoWindow: InfoWindow(title: 'Customer ${order.customerName}'),
            ),
          );

          marker.add(
            Marker(
              markerId: MarkerId('driver_$i'),
              position: driverLatLng,
              icon: driverIcon,
              // infoWindow: InfoWindow(title: 'Driver ${order.driverStateCountry}'),
              infoWindow: InfoWindow(title: 'Driver ${order.locationName}'),
            ),
          );

          final route = await getPolyline(customerLatLong, driverLatLng);
          if (route.isNotEmpty) {
            polyLines.add(
              Polyline(
                polylineId: PolylineId('route_$i'),
                points: route,
                color: const Color(0xFF4285F4),
                width: 5,
              ),
            );
          }
        }
      }

      emit(
        HomeLoadedState(
          ordersModel: orders,
          cameraPosition: cameraPosition,
          polyLines: polyLines,
          marker: marker,
        ),
      );
    } catch (e) {
      log("Error in fetchOrders: $e");
      // Optionally: emit an error state
    }
  }
  Future<List<LatLng>> getPolyline(LatLng start, LatLng end) async {
    final polylinePoints = PolylinePoints();

    final request = PolylineRequest(
      origin: PointLatLng(start.latitude, start.longitude),
      destination: PointLatLng(end.latitude, end.longitude),
      mode: TravelMode.driving,
    );

    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey:
          'AIzaSyCyyqHImZfYyt09rya-6YcD9wsTWbP0fsE', // Replace with env var in prod
      request: request,
    );

    if (result.points.isEmpty) return [];

    return result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }
}

Future<BitmapDescriptor> getCustomIcon(String assetPath) async {
  return await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(size: Size(48, 48)), // You can adjust size
    assetPath,
  );
}

void onFetchLocationDetails(FetchLocationDetailsEvent event, Emitter<HomeState> emit,) async {
  emit(LocationLoadingState());
  try {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(event.latitude, event.longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final city = place.locality ?? '';
      final country = place.country ?? '';
      final address = [
        place.name,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      emit(LocationLoaded(city: city, country: country, address: address));
    } else {
      emit(LocationError("Location not found"));
    }
  } catch (e) {
    emit(LocationError( "Error: ${e.toString()}"));
  }
}
