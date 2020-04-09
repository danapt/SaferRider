import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferrider/global/global.dart';

Future<LatLng> GetLocationFromAddress(String address)async{
  LatLng _latlng;
  try{
    var _getcoder = await Geocoder.google(place_key).findAddressesFromQuery(address);
    double _lat = _getcoder.first.coordinates.latitude;
    double _lng = _getcoder.first.coordinates.longitude;
    _latlng = new LatLng(_lat, _lng);
  }catch(e){
    print(e.toString());
  }
  return _latlng;
}

Future<String> GetAddressFromLocation(LatLng _coordinates)async{
  String _address = "";
  try{
    var _geocoder = await Geocoder.google(place_key).findAddressesFromCoordinates(new Coordinates(_coordinates.latitude, _coordinates.longitude));
    _address = _geocoder.first.addressLine;
  }catch(e){

  }
  return _address;
}