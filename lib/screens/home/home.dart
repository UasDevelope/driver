import 'package:carousel_slider/carousel_slider.dart';
import 'package:driver/blocs/earning/state.dart';
import 'package:driver/blocs/home/bloc.dart';
import 'package:driver/blocs/home/state.dart';
import 'package:driver/screens/home/tripCard.dart';
import 'package:driver/utils/const/app_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../blocs/earning/bloc.dart';
import '../../blocs/earning/event.dart';
import '../../blocs/home/event.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(37.3346, -121.8910),
    zoom: 14,
  );
  CameraPosition? _lastCameraPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EarningsBloc>().add(LoadEarningsEvent());
      context.read<HomeBloc>().add(HomeLoadedEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(userName: "Joseph", profileImage: AppImages.person),
      body: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (previous, current) => current is HomeLoadedState,
        listener: (context, state) async {
          if (state is HomeLoadedState && _mapController != null) {
            // Only animate if camera position changed
            if (_lastCameraPosition?.target != state.cameraPosition.target) {
              await _mapController!.animateCamera(
                CameraUpdate.newCameraPosition(state.cameraPosition),
              );
              _lastCameraPosition = state.cameraPosition;
            }
          }
        },
        buildWhen: (previous, current) =>
            current is HomeLoadingState || current is HomeLoadedState,
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HomeLoadedState) {
            return Stack(
              children: [
                // Google Map
                Positioned.fill(
                  child: GoogleMap(
                    polylines: state.polyLines,
                    initialCameraPosition: _defaultPosition,
                    zoomControlsEnabled:
                        state.ordersModel.isEmpty ? true : false,
                    myLocationEnabled: true,
                    indoorViewEnabled: true,
                    markers: state.marker,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      // Animate to the correct position on map creation
                      if (_lastCameraPosition?.target !=
                          state.cameraPosition.target) {
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(state.cameraPosition),
                        );
                        _lastCameraPosition = state.cameraPosition;
                      }
                    },
                  ),
                ),

                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      BlocBuilder<EarningsBloc, EarningsState>(
                        buildWhen: (previous, current) =>
                            current is EarningsLoading ||
                            current is EarningsLoaded,
                        builder: (context, state) {
                          if (state is EarningsLoaded) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "\$${state.earnings.totalEarnings}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.notifications_none),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 10,
                  right: 10,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 280,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: state.ordersModel.map((data) {
                      return Builder(
                        builder: (BuildContext context) {
                          return TripCard(
                            data: data,
                          ); // Your custom trip card widget
                        },
                      );
                    }).toList(),
                  ),
                ),
                // Positioned(
                //   bottom: 100,
                //   right: 20,
                //   child: FloatingActionButton(
                //     heroTag: 'testLocationBtn',
                //     child: Icon(Icons.location_searching),
                //     onPressed: () async {
                //       if (state is! HomeLoadedState ||
                //           state.ordersModel.isEmpty) return;
                //       // Get driver and first trainee location
                //       final driver = state.cameraPosition.target;
                //       final firstOrder = state.ordersModel.first;
                //       final trainee =
                //           LatLng(firstOrder.latitude!, firstOrder.longitude!);
                //       // Pick a random point between driver and trainee
                //       final random = Random();
                //       final t = random.nextDouble();
                //       final lat = driver.latitude +
                //           (trainee.latitude - driver.latitude) * t;
                //       final lng = driver.longitude +
                //           (trainee.longitude - driver.longitude) * t;
                //       // Emit updateLocation event
                //       final socketService =
                //           context.read<HomeBloc>().socketService;
                //       socketService.emit('locationUpdate', {
                //         'lat': lat,
                //         'lng': lng,
                //         // 'locationName': 'Random Test Location',
                //         'bookingId': firstOrder.bookingId,
                //         // 'updateType': 'continuous',
                //       });
                //       socketService.emit('updateLocation', {
                //         'latitude': lat,
                //         'longitude': lng,
                //         'locationName': 'Random Test Location',
                //         'bookingId': firstOrder.bookingId,
                //         'updateType': 'manual',
                //       });
                //       socketService.emit('sendLocation', {
                //         'lat': lat,
                //         'lng': lng,
                //         // 'locationName': 'Random Test Location',
                //         'bookingId': firstOrder.bookingId,
                //         // 'updateType': 'continuous',
                //       });
                //     },
                //   ),
                // ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
