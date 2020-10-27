import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_based_social_app/model/location_point.dart';

class PostLocationMapViewScreen extends StatefulWidget {

  final double zoom = 15;
  static const String router = '/PostLocationMapViewScreen';

  @override
  _PostLocationMapViewScreenState createState() => _PostLocationMapViewScreenState();
}

class _PostLocationMapViewScreenState extends State<PostLocationMapViewScreen> {

  GoogleMapController mapController;
  bool _isInit = true;
  LocationPoint postLocation;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      postLocation = ModalRoute.of(context).settings.arguments as LocationPoint;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void initMap() async {
    await mapController.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(postLocation.latitude, postLocation.longitude),
      widget.zoom
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Location'),
        elevation: 0.5,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(postLocation.latitude, postLocation.longitude),
          zoom: widget.zoom,
        ),
        onMapCreated: (controller) {
          mapController = controller;
          initMap();
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set.from([Marker(markerId: MarkerId('1'), position: LatLng(postLocation.latitude, postLocation.longitude))]),
      ),
    );
  }
}
