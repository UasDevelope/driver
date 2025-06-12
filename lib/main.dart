import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_routes.dart';
import 'core/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
void main() {
  runApp(MyApp());
}







class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getAppBlocProvider(),
      child: MaterialApp(
        // initialRoute: AppRoutes.splash,
        // debugShowCheckedModeBanner: false,
        // onGenerateRoute: AppRoutes.onGenerateRoute,
        home: SimpleMapScreen(),
      ),
    );
  }
}


class SimpleMapScreen extends StatefulWidget {
  @override
  _SimpleMapScreenState createState() => _SimpleMapScreenState();
}

class _SimpleMapScreenState extends State<SimpleMapScreen> {
  GoogleMapController? mapController;

  final LatLng _center = const LatLng(37.7749, -122.4194); // San Francisco

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Google Map')),
      body: GoogleMap(
         mapType:MapType.hybrid,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        myLocationEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
