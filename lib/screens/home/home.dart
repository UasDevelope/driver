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

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  late GoogleMapController _mapController;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.3346, -121.8910),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    context.read<EarningsBloc>().add(LoadEarningsEvent());
    context.read<HomeBloc>().add(HomeLoadedEvent());
    return Scaffold(
      drawer: CustomDrawer(userName: "Joseph", profileImage: AppImages.person),
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen:
            (previous, current) =>
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
                    initialCameraPosition: _initialPosition,
                    zoomControlsEnabled:
                        state.ordersModel.isEmpty ? true : false,
                    myLocationEnabled: true,
                    indoorViewEnabled: true,
                    markers: state.marker,
                    onMapCreated: (controller) {
                      _mapController = controller;
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
                        builder:
                            (context) => Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.menu),
                                onPressed:
                                    () => Scaffold.of(context).openDrawer(),
                                color: Colors.black,
                              ),
                            ),
                      ),
                      BlocBuilder<EarningsBloc, EarningsState>(
                        buildWhen:
                            (previous, current) =>
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
                    items:
                        state.ordersModel.map((data) {
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
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
