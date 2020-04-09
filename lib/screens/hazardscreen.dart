import 'package:flutter/material.dart';
import 'package:saferrider/screens/addHazardDialog.dart';
import 'package:saferrider/screens/menu.dart';
import 'package:saferrider/global/global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferrider/utils/getuserlocation.dart';
import 'package:saferrider/utils/manageHazards.dart';
import 'package:saferrider/screens/editHazardDialog.dart';
import 'package:toast/toast.dart';
import 'package:saferrider/models/harzard.dart';
import 'dart:convert';
import 'package:saferrider/utils/selectDestinationByGoogle.dart';
import 'package:saferrider/utils/getLocationFromAddress.dart';



class HazardScreen extends StatefulWidget {
  @override
  _HazardScreenState createState() => _HazardScreenState();
}

class _HazardScreenState extends State<HazardScreen> {

  bool _isDeletingHazard = false;
  //google map variables==============================================================
  GoogleMapController _controller;
  final Set<Marker> _markers = Set();
  Marker _addHazardMarker;

  Marker _newHazardMarker;

  String _selectedHazardId = "";

  final _locationController = new TextEditingController();

  //init position=============
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.5033, 0.1195),
    zoom: 100,
  );
  //=====================================================================================

  bool _showHazard = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHazard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hazard"),
          actions: <Widget>[

            //sing out button........................................
           MenuWidget("hazard")
          ],
        ),
        body: Stack(
          children: <Widget>[
            //google map screen--------------------------------------------------------------------------------
            Container(
              child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: _markers,
                  onTap: _selectMapForHazard,
                  //when loading google map, callback00000000000000000000000000000000000000000000000000000
                  onMapCreated: _onMapCreated
              ),
            ),
            //-------------------------------------------------------------------------------------------------
            //select destination field and mylocation button----------------------------------------------
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child:IconButton(icon: Image.asset("assets/images/hazard.png", color: _showHazard?Colors.orange:Colors.grey[800],), onPressed: (){
                              _selectedHazardId = "";
                              if(allHazards.isEmpty) return;
                              if(_controller == null) return;
                              _showHazard = !_showHazard;
                              if(!_showHazard){
                                _markers.clear();
                                if(_addHazardMarker != null)
                                  _markers.add(_addHazardMarker);
                              }else{
                                _showAllHazard();
                              }
                              setState(() {

                              });
                            })
                            ,
                          ),

                          InkWell(
                            onTap: _getLocaion,
                            child: Container(
                              width: MediaQuery.of(context).size.width-150,
                              child: TextField(
                                controller: _locationController,
                                enabled: false,
                                style: TextStyle(
                                    color: Colors.black
                                ),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10, right: 10, top: 0, bottom: 0
                                    ),
                                    prefixIcon: Icon(Icons.location_on, color: Colors.red[700],),
                                    labelText: "Select Location",
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

                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child:IconButton(icon: Icon(Icons.my_location, size: 40, color: Colors.grey[800],), onPressed: (){
                              _selectedHazardId = "";
                              if(_controller == null) return;
                              getUserLocation().then((center){
                                _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                    target: center == null ? LatLng(0, 0) : center, zoom: 17.0)));
                              });
                              setState(() {

                              });
                            })
                            ,
                          ),
                        ],
                      ),
                      _selectedHazardId == ""?
                          Container():
                          Container(height: 100,),
                      _selectedHazardId == ""?
                      Container():
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.black)
                            ),
                            child:
                            IconButton(
                              onPressed: _editHazard,
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                            ),),
                          SizedBox(width: 20,),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.black)
                            ),
                            child: _isDeletingHazard?
                            CircularProgressIndicator():
                            IconButton(
                              onPressed: _deletHazard,
                              icon: Icon(Icons.delete_forever),
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
              ),
            ),
            //----------------------------------------------------------------------------------------------
          ],
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      //draw route button-----------------------------------------------------------------------
      floatingActionButton: RaisedButton(
        color: _addHazardMarker == null?Colors.grey[700]:Colors.orange[700],
        child: Text("Add Hazard", style: TextStyle(color: Colors.white),),
        onPressed: _addHazard,
      )
      //----------------------------------------------------------------------------------------

    );
  }

  _getLocaion()async{
    //"lib/utils/selectDestinationByGoogle"
    String origination = await SelectDestinationByGoogle(context);
    print(origination);
    if(origination == null)return;
    _locationController.text = origination;
    try{
      //"lib/utils/getLocationFromAddress.dart"
      LatLng _originLocation = await GetLocationFromAddress(origination);

      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _originLocation == null ? LatLng(0, 0) : _originLocation, zoom: 17.0)));
      //add self and destination marker++++++++++++++++++++++++++++++++++++++++++++++++
      _selectedHazardId = "";
      _addHazardMarker = Marker(markerId: MarkerId("hazard"),
        position: _originLocation,
      );
      _markers.add(_addHazardMarker);
      setState(() {

      });

      setState(() {

      });
    }catch(e){
      print(e.toString());
    }
  }

  _getHazard()async{
    allHazards = [];
    allHazards = await getHazard();
  }

  _onMapCreated(GoogleMapController controller){
    //when loading google map, callback
    _controller = controller;

    //go to my location using camera.............
    getUserLocation().then((center){
      _addHazardMarker = Marker(markerId: MarkerId("hazard"),
        position: center,
      );
      _markers.add(_addHazardMarker);
      setState(() {

      });
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: center == null ? LatLng(0, 0) : center, zoom: 17.0)));
    });
  }

  _selectMapForHazard(LatLng _latlng){
    _selectedHazardId = "";
    _addHazardMarker = Marker(markerId: MarkerId("hazard"),
      position: _latlng,
    );
    _markers.add(_addHazardMarker);
    print("click map==================================");
    setState(() {

    });
  }

  _addHazard()async{
    if(_addHazardMarker == null){
      Toast.show("Please select hazard position in google map", context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    String result = await showDialog(context: context, builder: (context){
      return AddHazardDialog(lat: _addHazardMarker.position.latitude, lng: _addHazardMarker.position.longitude,);
    });
    if(result == null) return;
    print(result);
    Hazard _currentHazard = Hazard.fromJson(json.decode(result));
    allHazards.add(_currentHazard);
    _newHazardMarker = Marker(markerId: MarkerId("newhazard"),
      infoWindow: InfoWindow(
        title: _currentHazard.title,
        snippet: _currentHazard.description,
      ),
      icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)), "${_currentHazard.image}"),
      position: LatLng(_currentHazard.lat, _currentHazard.lng),
    );
    _markers.add(_newHazardMarker);
    setState(() {

    });
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currentHazard.lat, _currentHazard.lng), zoom: 20.0)));
  }

  _showAllHazard()async{
    print("show all hazard");
    for(var item in allHazards){
      _markers.add(Marker(markerId: MarkerId(item.uid),
          infoWindow: InfoWindow(
            title: item.title,
            snippet: item.description,
          ),
          icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)), "${item.image}"),
          position: LatLng(item.lat, item.lng),
          onTap: ()async{
            _selectedHazardId = item.uid;
            setState(() {

            });
          },
    ));
    }
  }

  _deletHazard()async{
    try{
      _isDeletingHazard = true;
      setState(() {

      });
      await deleteHazard(_selectedHazardId);
      allHazards.removeWhere((item) => item.uid == _selectedHazardId);
      _markers.remove(_markers.firstWhere((Marker marker) => marker.markerId.value == _selectedHazardId));
    }catch(e){

    }
    _isDeletingHazard = false;
    _selectedHazardId = "";
    setState(() {

    });
  }

  _editHazard()async{
    Hazard _editinHazard = allHazards.where((item) => item.uid == _selectedHazardId).toList()[0];
    String result = await showDialog(context: context, builder: (context){
      return EditHazardDialog(_editinHazard);
    });

    _selectedHazardId = "";

    if(result == null){
      setState(() {
      });
      return;
    }

    Hazard _returnhazard = Hazard.fromJson(json.decode(result));
    allHazards.remove(_editinHazard);
    allHazards.add(_returnhazard);
    _markers.remove(_markers.firstWhere((Marker marker) => marker.markerId.value == _returnhazard.uid));
    _markers.add(
        Marker(markerId: MarkerId(_returnhazard.uid),
          infoWindow: InfoWindow(
            title: _returnhazard.title,
            snippet: _returnhazard.description,
          ),
          icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(64, 64)), "${_returnhazard.image}"),
          position: LatLng(_returnhazard.lat, _returnhazard.lng),
          onTap: ()async{
            _selectedHazardId = _returnhazard.uid;
            setState(() {

            });
          },
        )
    );
    setState(() {

    });
  }
}
