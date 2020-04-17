import 'package:location/location.dart' as LocationManage;
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng> getUserLocation() async {
  LatLng center;
  LocationManage.LocationData currentLocation;
  var location = new LocationManage.Location();
  try {
    currentLocation = await location.getLocation();
    final lat = currentLocation.latitude;
    final lng = currentLocation.longitude;
    center = LatLng(lat, lng);
  } on Exception {
    currentLocation = null;
  }
  return center;
}