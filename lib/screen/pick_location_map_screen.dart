import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_based_social_app/model/location_point.dart';

class PickLocationMapScreen extends StatefulWidget {
  final double zoom = 15;
  static const String router = '/PickLocationMapScreen';

  @override
  _PickLocationMapScreenState createState() => _PickLocationMapScreenState();
}

class _PickLocationMapScreenState extends State<PickLocationMapScreen> {
  GoogleMapController mapController;
  bool _isInit = true;
  LocationPoint _initialLocation;

  LocationPoint _currentSelectedLocation;
  void Function(LocationPoint) _setLocation;

  void _updateLocation(LocationPoint clickedLocation) {
    setState(() {
      _currentSelectedLocation = clickedLocation;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Map<String, dynamic> parameters =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      _initialLocation = parameters['initialLocation'];
      _currentSelectedLocation = _initialLocation;
      _setLocation = parameters['setLocation'];
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
        LatLng(_initialLocation.latitude, _initialLocation.longitude),
        widget.zoom));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        elevation: 0.5,
        actions: [
          FlatButton(
            child: Text(
              'OK',
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              _setLocation(_currentSelectedLocation);
              Navigator.of(context).pop();
              return;
            },
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_initialLocation.latitude, _initialLocation.longitude),
          zoom: widget.zoom,
        ),
        onMapCreated: (controller) {
          mapController = controller;
          initMap();
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set.from([
          Marker(
              markerId: MarkerId('1'),
              position: LatLng(_currentSelectedLocation.latitude,
                  _currentSelectedLocation.longitude))
        ]),
        onTap: (latLng) {
          _updateLocation(LocationPoint(latLng.longitude, latLng.latitude));
        },
      ),
    );
  }
}
