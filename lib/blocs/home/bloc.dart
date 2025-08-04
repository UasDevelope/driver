import 'dart:developer';

import 'package:driver/api/api_const.dart';
import 'package:driver/blocs/home/event.dart';
import 'package:driver/blocs/home/state.dart';
import 'package:driver/services/socket_service.dart';
import 'package:driver/utils/const/app_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/order.dart';
import '../../repositories/CurrentLocationRepository.dart';
import '../../repositories/orders_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  OrdersRepository ordersRepo = OrdersRepository();
  final CurrentLocationRepository currentLocationRepository;
  final SocketService socketService;
  LatLng? _driverLatLng;
  List<OrdersModel> _orders = [];
  Set<Polyline> _polyLines = {};
  Set<Marker> _markers = {};
  CameraPosition? _cameraPosition;

  HomeBloc(
      {required this.currentLocationRepository, SocketService? socketService})
      : socketService = socketService ?? SocketService(),
        super(HomeInitialState()) {
    on<HomeLoadedEvent>(fetchOrders);
    on<FetchLocationDetailsEvent>(onFetchLocationDetails);
    on<DriverLocationUpdatedEvent>(_onDriverLocationUpdated);

    // Listen for live location updates
    _initSocketListener();
  }

  void _initSocketListener() async {
    await socketService.initSocket();
    socketService
        .emit('trackBooking', {'bookingId': "6880ba6e37501160f81886bc"});

    await socketService.on("error", (data) {
      log("error data is $data");
    });
    await socketService.on("receiveLocation", (data) {
      log("Selected location is $data");
    });
    await socketService.on('locationUpdated', (data) {
      log("Location data ${data}");
      if (data != null && data['location'] != null) {
        add(DriverLocationUpdatedEvent(
          userId: data['userId'] ?? '',
          latitude: data['location']['latitude']?.toDouble() ?? 0.0,
          longitude: data['location']['longitude']?.toDouble() ?? 0.0,
          eta: data['eta']?.toString(),
          timestamp: data['timestamp']?.toString(),
        ));
      }
    });
  }

  void fetchOrders(HomeLoadedEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      // 1. Get current location
      final (double driverLat, double driverLong, String driverLocation) =
          await currentLocationRepository.getCurrentLocation();
      final LatLng driverLatLng = LatLng(driverLat, driverLong);
      _driverLatLng = driverLatLng;
      // 2. Fetch orders
      List<OrdersModel> orders =
          await ordersRepo.getBookings(ApiConstants.inProgressBookings);
      _orders = orders;
      // Wait for socket connection before joining rooms
      await socketService.waitUntilReady();
      // Join room for each booking to receive live updates
      for (final order in orders) {
        if (order.bookingId != null) {
          // socketService.emit('trackBooking', {'bookingId': order.bookingId});
        }
      }
      final Set<Polyline> polyLines = {};
      final Set<Marker> marker = {};
      CameraPosition cameraPosition = CameraPosition(
        target: driverLatLng,
        zoom: 14,
      );
      _cameraPosition = cameraPosition;
      // 3. For each order, add markers and polylines
      for (int i = 0; i < orders.length; i++) {
        final order = orders[i];
        // Assume order.latitude, order.longitude are trainee/student location
        final LatLng traineeLatLng = LatLng(order.latitude!, order.longitude!);
        // Red marker for trainee
        final traineeIcon = await getCustomIcon(AppImages.end); // Use red icon
        marker.add(
          Marker(
            markerId: MarkerId('trainee_$i'),
            position: traineeLatLng,
            icon: traineeIcon,
            infoWindow: InfoWindow(title: 'Trainee: ${order.customerName}'),
          ),
        );
        // Green marker for driver (current location)
        final driverIcon =
            await getCustomIcon(AppImages.start); // Use green icon
        log("Driver lat long " +
            driverLatLng.toString() +
            " and trainee " +
            traineeLatLng.toString());
        marker.add(
          Marker(
            markerId: MarkerId('driver'),
            position: driverLatLng,
            icon: driverIcon,
            infoWindow: InfoWindow(title: 'Driver (You)'),
          ),
        );
        // Polyline from driver to trainee
        final route = await getPolyline(driverLatLng, traineeLatLng);
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
      _polyLines = polyLines;
      _markers = marker;
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
    try {
      final polylinePoints = PolylinePoints();

      final request = PolylineRequest(
        origin: PointLatLng(start.latitude, start.longitude),
        destination: PointLatLng(end.latitude, end.longitude),
        mode: TravelMode.driving,
      );

      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: 'AIzaSyCyyqHImZfYyt09rya-6YcD9wsTWbP0fsE',
        request: request,
      );

      if (result.points.isEmpty) return [];

      return result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _onDriverLocationUpdated(
      DriverLocationUpdatedEvent event, Emitter<HomeState> emit) async {
    // Update driver marker and polylines
    if (_orders.isEmpty) return;
    final LatLng newDriverLatLng = LatLng(event.latitude, event.longitude);
    _driverLatLng = newDriverLatLng;
    final Set<Marker> updatedMarkers =
        _markers.where((m) => !m.markerId.value.startsWith('driver')).toSet();
    final driverIcon = await getCustomIcon(AppImages.start);
    updatedMarkers.add(
      Marker(
        markerId: MarkerId('driver'),
        position: newDriverLatLng,
        icon: driverIcon,
        infoWindow: InfoWindow(title: 'Driver (You)'),
      ),
    );
    final Set<Polyline> updatedPolylines = {};
    for (int i = 0; i < _orders.length; i++) {
      final order = _orders[i];
      final LatLng traineeLatLng = LatLng(order.latitude!, order.longitude!);
      final route = await getPolyline(newDriverLatLng, traineeLatLng);
      if (route.isNotEmpty) {
        updatedPolylines.add(
          Polyline(
            polylineId: PolylineId('route_$i'),
            points: route,
            color: const Color(0xFF4285F4),
            width: 5,
          ),
        );
      }
    }
    _markers = updatedMarkers;
    _polyLines = updatedPolylines;
    final cameraPosition = CameraPosition(target: newDriverLatLng, zoom: 14);
    _cameraPosition = cameraPosition;
    emit(HomeLoadedState(
      ordersModel: _orders,
      cameraPosition: cameraPosition,
      polyLines: updatedPolylines,
      marker: updatedMarkers,
    ));
  }
}

Future<BitmapDescriptor> getCustomIcon(String assetPath) async {
  return await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(size: Size(48, 48)), // You can adjust size
    assetPath,
  );
}

void onFetchLocationDetails(
  FetchLocationDetailsEvent event,
  Emitter<HomeState> emit,
) async {
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
    emit(LocationError("Error: ${e.toString()}"));
  }
}
