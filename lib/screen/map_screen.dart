import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_based_social_app/model/location_point.dart';

class MapScreen extends StatefulWidget {

  final double _zoom = 15;
  final LocationPoint initialLocation;

  MapScreen({this.initialLocation = const LocationPoint(37.442, -122.048)});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  StreamSubscription locationSubscription;
  Location locationTracker = Location();
  GoogleMapController mapController;

  void initMap() async {
    LocationData currentLocation = await locationTracker.getLocation();
    await mapController.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(currentLocation.latitude, currentLocation.longitude), widget._zoom
    ));

    locationSubscription = locationTracker.onLocationChanged.listen((newLocationData) {
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(newLocationData.latitude, newLocationData.longitude), widget._zoom
        ));
      }
    });
  }

  @override
  void dispose() {
    if (locationSubscription != null) {
      locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude),
          zoom: widget._zoom,
        ),
        onMapCreated: (controller) {
          mapController = controller;
          initMap();
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,

      ),
    );
  }
}
