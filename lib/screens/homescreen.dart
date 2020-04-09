import 'package:flutter/material.dart';
import 'package:saferrider/screens/menu.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:saferrider/global/global.dart';
import 'package:saferrider/utils/getuserlocation.dart';
import 'package:saferrider/utils/selectDestinationByGoogle.dart';
import 'package:saferrider/utils/getLocationFromAddress.dart';
import 'package:saferrider/utils/getRouteByMap.dart';
import 'package:toast/toast.dart';
import 'package:saferrider/utils/getAccidentLocations.dart';
import 'package:saferrider/utils/manageHazards.dart';
import 'package:saferrider/utils/manageWeather.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isShowAccidents = false;
  bool _isShowHazards = false;
  //google map variables==============================================================
  GoogleMapController _controller;
  final Set<Marker> _markers = Set();
  final Set<Circle> _circles = Set();
  final _DestinationController = TextEditingController();
  final _OriginationController = TextEditingController();

  int _polylineCount = 1;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  LatLng _originLocation;
  LatLng _destinationLocation;

  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  //init position=============
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.350521, -6.260984),
    zoom: 11,
  );
  //=====================================================================================

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHazard();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            //sing out button........................................
           MenuWidget("home")
          ],
        ),
        body: Stack(
          children: <Widget>[
            //google map screen--------------------------------------------------------------------------------
            Container(
              child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  polylines: Set<Polyline>.of(_polylines.values),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: _markers,
                  circles: _circles,

                  onMapCreated: _onMapCreated
              ),
            ),
            //-------------------------------------------------------------------------------------------------

            //select destination field and mylocation button----------------------------------------------
            Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Material(
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        InkWell(

                          //get Destination function by google place api2222222222222222222222222222222222222222
                          onTap: _getOrigination,
                          child: Container(
                            child: TextField(
                              controller: _OriginationController,
                              enabled: false,
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 0
                                  ),
                                  prefixIcon: Icon(Icons.location_on, color: Colors.red[700],),
                                  labelText: "Origination",
                                  labelStyle: TextStyle(
                                      color: Colors.black87
                                  ),
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                          ),
                        ),
                        InkWell(

                          //get Destination function by google place api2222222222222222222222222222222222222222
                          onTap: _getDestination,
                          child: Container(
                            child: TextField(
                              controller: _DestinationController,
                              enabled: false,
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 10, right: 10, top: 0, bottom: 0
                                  ),
                                  prefixIcon: Icon(Icons.location_on, color: Colors.blue[800],),
                                  labelText: "Destination",
                                  labelStyle: TextStyle(
                                      color: Colors.black87
                                  ),
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[

                            //+++++++++++++++++++++ show/hide hazards button ++++++++++++++++++++++++++++++++++
                            Container(
                              child: IconButton(
                                onPressed: (){
                                  if(allHazards.isEmpty){
                                    return;
                                  }
                                  setState(() {
                                    _isShowHazards = !_isShowHazards;
                                  });

                                  if(_isShowHazards){
                                    _showHazard();
                                  }else{
                                    _hideHazard();
                                  }
                                },
                                icon: Image.asset("assets/images/hazard.png", color: _isShowHazards?Colors.orange[700]:Colors.grey,),
                              ),
                            ),
                            //+++++++++++++++++++++ show/hide accidents button ++++++++++++++++++++++++++++++++++
                            Container(
                              child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    _isShowAccidents = !_isShowAccidents;
                                  });

                                  if(_isShowAccidents){
                                    _showAccident();
                                  }else{
                                    _hideAccident();
                                  }
                                },
                                icon: Image.asset("assets/images/warning.png",color: _isShowAccidents?Colors.red[700]:Colors.grey, width: 28, height: 28,),
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),

                      //select destination field and mylocation button----------------------------------------------
                      Container(
                        padding: EdgeInsets.only(right: 10, bottom: 20),
                        child:IconButton(icon: Icon(Icons.my_location, size: 40, color: Colors.grey[800],), onPressed: (){
                          if(_controller == null) return;
                          getUserLocation().then((center)async{
                            _markers.add(Marker(markerId: MarkerId("self"),
                              infoWindow: InfoWindow(
                                  title: "Origination"
                              ),
                              position: center,
                            ));
                            _originLocation = center;
                            _OriginationController.text = await GetAddressFromLocation(_originLocation);
                            setState(() {

                            });
                            _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
                          });
                        })
                        ,
                      ),
                    ],
                  ),
                ],
              )
            ),
            //----------------------------------------------------------------------------------------------
          ],
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //draw route button-----------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(onPressed: (){
        //draw route function1111111111111111111111111111111111111111111111111111111
        _drawRoute();
      },
        backgroundColor: Colors.white,
        elevation: 10,
        child: Image.asset("assets/images/address_icon.png"),
      ),
      //----------------------------------------------------------------------------------------
    );
  }

  //when loading google map, callback00000000000000000000000000000000000000000000000000000
  _onMapCreated(GoogleMapController controller){
    _controller = controller;
    //go to my location using camera.............
    getUserLocation().then((center)async{
      callWeather(center.latitude, center.longitude);
      _originLocation = center;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
      _markers.add(Marker(markerId: MarkerId("self"),
        infoWindow: InfoWindow(
          title: "Origination"
        ),
        position: _originLocation,
      ));
      _OriginationController.text = await GetAddressFromLocation(_originLocation);
      setState(() {

      });
    });
  }

  _getHazard()async{
    allHazards = [];
    allHazards = await getHazard();
  }

  //++++++++++++++++++++++++++++++++++++++++++++++++Draw Safest Route+++++++++++++++++++++++++++++++++++++++++++++

  //get Origination function by google place api2222222222222222222222222222222222222222
  _getOrigination()async{
    //"lib/utils/selectDestinationByGoogle"
    String origination = await SelectDestinationByGoogle(context);
    print(origination);
    if(origination == null)return;
    _OriginationController.text = origination;
    try{
      //"lib/utils/getLocationFromAddress.dart"
      _originLocation = await GetLocationFromAddress(origination);

      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _originLocation == null ? LatLng(0, 0) : _originLocation, zoom: 17.0)));
      //add self and destination marker++++++++++++++++++++++++++++++++++++++++++++++++
      _markers.add(Marker(markerId: MarkerId("self"),
        position: _originLocation,
        infoWindow: InfoWindow(
            title: "Origination"
        ),
        zIndex: 1
      ));

      setState(() {

      });
    }catch(e){
      print(e.toString());
    }
  }


  //get Destination function by google place api2222222222222222222222222222222222222222
  _getDestination()async{
    _DestinationController.text = "";
    _polylines.clear();
    _markers.clear();
    _circles.clear();
    _restoreMarkers();
    //"lib/utils/selectDestinationByGoogle"
    String Destination = await SelectDestinationByGoogle(context);
    print(Destination);
    _DestinationController.text = Destination;
    try{
      _destinationLocation = await GetLocationFromAddress(Destination);
      var _latFrom = _originLocation.latitude;
      var _lngFrom = _originLocation.longitude;
      var _latTo = _destinationLocation.latitude;
      var _lngTo = _destinationLocation.longitude;
      var sLat, sLng, nLat, nLng;

      if(_latFrom <= _latTo) {
        sLat = _latFrom;
        nLat = _latTo;
      } else {
        sLat = _latTo;
        nLat = _latFrom;
      }

      if(_lngFrom <= _lngTo) {
        sLng = _lngFrom;
        nLng = _lngTo;
      } else {
        sLng = _lngTo;
        nLng = _lngFrom;
      }

      _controller.animateCamera(CameraUpdate.newLatLngBounds( LatLngBounds(
        southwest: LatLng(sLat, sLng),
        northeast: LatLng(nLat, nLng),
      ), 80));


      _markers.add(Marker(
        markerId: MarkerId("destination"),
        position: _destinationLocation,
          infoWindow: InfoWindow(
              title: "Destination"
          ),
        icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40)), "assets/images/destination.png")
      ));

      setState(() {

      });
    }catch(e){
      print(e.toString());
    }
  }


  //draw route function1111111111111111111111111111111111111111111111111111111
  _drawRoute(){
    if(_DestinationController.text == ""){
      Toast.show("Plese select your Destination", context, gravity: Toast.CENTER);
      return;
    }

    //get multi route points using google direction api.................................................
    _getPolylinesWithLocation();
  }


  //get multi route points using google direction api.................................................
  Future _getPolylinesWithLocation() async {
    _circles.clear();
    _polylines.clear();
    List<List<LatLng>> _coordinates;
//    _coordinates = await HereApiHelper().getRoutesList(_originLocation, _destinationLocation);

    //get multi route list by google direction api "lib/utils/getRouteBytMap"
    _coordinates = await GetRouteByMap().getRoutesList(_originLocation, _destinationLocation, "driving");
    // _coordinates has all route points from google map direction api.

    List<Map<String, int>> dangerNumbers = [];
    int index = 0;

    //put danger areas in google map............................................
    for(var oneRoute in _coordinates){
      int i = 0;
      for(var points in oneRoute){

        //Here all points of all routes is checking, that the point is at accident area
        List<LatLng> _accidentPositions = getAccidentLocations(points); // go "lib/utils/getAccidentLocations.dart"
        for(var point in _accidentPositions){
//          _addAccidentMarkers(point);
        _addAccidentCircles(point);
          i++;
        }
      }
      dangerNumbers.add({"id": index, "value": i});
      index++;
    }
    print("checking danger_____________________________________________________");
    print(dangerNumbers);
    dangerNumbers.sort((a,b){
      return a['value'].compareTo(b['value']);
    });
    print(dangerNumbers.last);

    //draw safest route by danger points number
    for(int i = 0; i < _coordinates.length; i++){
      Color color = Colors.blue[800];
      int pattern = 1;
      if(i == dangerNumbers.first['id']){
        color = Colors.green[800];
        pattern = 0;
      }
      if(dangerNumbers.length != 1)
      if(i == dangerNumbers.last['id']){
        color = Colors.red[800];
        pattern = 3;
      }
      _addPolyline(_coordinates[i], color, pattern);
    }
//    int i=0;
//    for(var item in _coordinates){
//      print(item[0].longitude);
//      int pattern = 1;
//      Color color = Colors.red;
//      if(i%2==0){
//        color = Colors.green;
//        pattern = 0;
//      }
//      _addPolyline(item, color, pattern);
//      i++;
//    }
  }

  //pick accident markers==============================================
  _addAccidentMarkers(LatLng _position)async{
    int id = Random().nextInt(100000);
    _markers.add(Marker(
        markerId: MarkerId("dangeraous $id"),
        position: _position,
        infoWindow: InfoWindow(title: "Danger Area $id"),
        icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40)), "assets/images/hazard.png")
    ));
    setState(() {

    });
  }

  //pick accident points with circle of 40 radius
  _addAccidentCircles(LatLng _position)async{
    int id = Random().nextInt(100000);
    _circles.add(Circle(circleId: CircleId("$id"), center: _position, radius: 40, fillColor: Colors.deepOrangeAccent.withOpacity(0.5), strokeWidth: 0));
    setState(() {

    });
  }

  //draw polyline for route
  _addPolyline(List<LatLng> _coordinates, Color _color, int pattern_index,) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[pattern_index],
        color: _color,
        points: _coordinates,
        width: 3,
        zIndex: 10-pattern_index,
        onTap: () {

        });

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  _showAccident()async{
    for(var item in accidentData){
      _markers.add(
        Marker(
          markerId: MarkerId("${item.latitude}${item.longitude}"),
          position: LatLng(item.latitude, item.longitude),
          icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(20, 20)), "assets/images/alert.png")
        ),

      );
    }
  }

  _hideAccident(){
    _markers.clear();
    _restoreMarkers();
  }

  _showHazard()async{
    for(var item in allHazards){
      _markers.add(Marker(markerId: MarkerId(item.uid),
          infoWindow: InfoWindow(
            title: item.title,
            snippet: item.description,
          ),
          icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)), "${item.image}"),
    position: LatLng(item.lat, item.lng),
    ));
  }
  }

  _hideHazard() {
    _markers.clear();
    _restoreMarkers();
  }

  _restoreMarkers()async{
    if(_originLocation != null){
      _markers.add(Marker(markerId: MarkerId("self"),
        position: _originLocation,
      ));
    }

    if(_DestinationController.text != ""){
      _markers.add(Marker(
          markerId: MarkerId("destination"),
          position: _destinationLocation,
          icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40)), "assets/images/destination.png")
    ));
    }

    if(_isShowAccidents){
      print("restore accidents================================================");
      _showAccident();
    }

    if(_isShowHazards){
      print("restore hazard================================================");
      _showHazard();
    }
    setState(() {

    });
  }

}
