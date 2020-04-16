import 'package:http/http.dart' as http;
import 'package:saferrider/global/global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';


class GetRouteByMap {

  //getting multi route by google map direction api 
  //https://maps.googleapis.com/maps/api/directions/json?alternatives=true&key=AIzaSyC5SfKBN7YPJ323CJYBfSYnjBSbpiz9qCI
  Future<List<List<LatLng>>> getRoutesList(LatLng _originlatlng, LatLng _destinationlatlng, String mode)async{
    String _origin = "${_originlatlng.latitude},${_originlatlng.longitude}";
    String _destination = "${_destinationlatlng.latitude},${_destinationlatlng.longitude}";
    List<List<LatLng>> _latlnglist = [];
    String endpoint = "&origin=$_origin&destination=$_destination&mode=$mode";
    String url = base_url_of_map + endpoint;
//url = https://maps.googleapis.com/maps/api/directions/json?alternatives=true&key=AIzaSyC5SfKBN7YPJ323CJYBfSYnjBSbpiz9qCI
    //AIzaSyA_YK1Dk-YYLpZJRo-AC-ckfd0lF8vjSwo
//&origin=$_origin
//&destination=$_destination
//&mode=$mode
    print(url);
    try{
      var response = await http.get(url, headers: {"Content-Type" : "application/json"});// http request to get route info
      Map data = json.decode(response.body);
      for(var route in data["routes"]){
        List<LatLng> _oneroutelatlngs = [];

        //getting route points from hashcode
        _oneroutelatlngs = _convertToLatLng(_decodePoly(route['overview_polyline']['points']));
        _latlnglist.add(_oneroutelatlngs);
      }
    }catch(e){
      print(e.toString());
    }
    return _latlnglist;
  }


//getting routes points from hashcode code used from https://medium.com/@shubham.narkhede8/flutter-google-map-with-direction-6a26ad875083
  //this apply for both methods _decodePoly and _convertToLatLng

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    return lList;
  }

//getting LatLng from points
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

}