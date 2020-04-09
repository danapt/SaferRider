import 'package:http/http.dart' as http;
import 'package:saferrider/global/global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class HereApiHelper {
  Future<List<List<LatLng>>> getRoutesList(LatLng _originlatlng, LatLng _destinationlatlng)async{
    String _origin = "geo!${_originlatlng.latitude},${_originlatlng.longitude}";
    String _destination = "geo!${_destinationlatlng.latitude},${_destinationlatlng.longitude}";
    List<List<LatLng>> _latlnglist = [];
    String endpoint = "&waypoint0=$_origin&waypoint1=$_destination";
    String url = base_url_of_here + endpoint;
    print(url);
    try{
      var response = await http.get(url, headers: {"Content-Type" : "application/json"});
      Map data = json.decode(response.body);
      for(var route in data["response"]["route"]){
        List<LatLng> _oneroutelatlngs = [];
        for(var maneuverItem in route['leg'][0]['maneuver']){
          double _lat = maneuverItem['position']['latitude'];
          double _lng = maneuverItem['position']['longitude'];
          print("$_lat, $_lng");
          _oneroutelatlngs.add(new LatLng(_lat, _lng));
        }
        _latlnglist.add(_oneroutelatlngs);
      }
    }catch(e){
      print(e.toString());
    }
    return _latlnglist;
  }
}