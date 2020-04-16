import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferrider/global/global.dart';
import 'package:saferrider/models/accident.dart';


//checking accidents function
List<LatLng> getAccidentLocations(LatLng _routeLocation){
  List<LatLng> _list = [];
  List<Accident> _dataList = [];

  //add all accidents points and all hazards points
  for(var item in accidentData){
    _dataList.add(item);
  }
  for(var item in allHazards){
    _dataList.add(new Accident(latitude: item.lat,longitude: item.lng));
  }


  //checking that the circle(center: _routeLocation, radius: 50) has accident or hazard points
  for(var item in _dataList){
    if(item.latitude < _routeLocation.latitude + 0.0002 && item.latitude > _routeLocation.latitude - 0.0002 &&
        item.longitude < _routeLocation.longitude + 0.0006 && item.longitude > _routeLocation.longitude - 0.0006){
      _list.add(new LatLng(item.latitude, item.longitude));
    }
  }

  //return checked accident and hazard points
  return _list;
}

