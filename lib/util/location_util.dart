import 'package:location/location.dart';
import 'package:location_based_social_app/model/location_point.dart';

Future<LocationPoint> getCurrentLocation() async {
  final Location locationTracker = Location();
  final LocationData currentLocation = await locationTracker.getLocation();
  return LocationPoint(currentLocation.longitude, currentLocation.latitude);
}
