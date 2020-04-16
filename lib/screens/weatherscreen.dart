import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter/material.dart';
import 'package:saferrider/screens/menu.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:saferrider/utils/manageWeather.dart';
import 'package:saferrider/utils/getuserlocation.dart';
import 'package:saferrider/global/global.dart';
import 'package:toast/toast.dart';
import 'package:saferrider/models/weathersettings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {


  bool _isLoading = false;
  double _windspeed = 4;

  int startdegree = 20;
  int enddegree = 40;

  double _lowertemp = -5;
  double _uppertemp = 25;

  bool _checkheavyrain = true;
  bool _checkstorm = true;
  bool _checkheavycloud = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Settings"),
        actions: <Widget>[
          MenuWidget("weather")
        ],
      ),

      body:Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Text("Temperature", style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20
                  ),),

                  SizedBox(height: 20,),
                  //temperature setting
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.blue[700],
                      inactiveTrackColor: Colors.red[300],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.orange,
                      overlayColor: Colors.transparent,
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: Colors.red[100],
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.blue,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: frs.RangeSlider(
                      min: -10.0,
                      max: 40.0,
                      lowerValue: _lowertemp,
                      upperValue: _uppertemp,
                      divisions: 100,
                      showValueIndicator: true,
                      valueIndicatorMaxDecimals: 1,
                      onChanged: (double newLowerValue, double newUpperValue) {
                        setState(() {
                          _lowertemp = newLowerValue;
                          _uppertemp = newUpperValue;
                        });
                      },
                      onChangeStart:
                          (double startLowerValue, double startUpperValue) {
                        print(
                            'Started with values: $startLowerValue and $startUpperValue');
                      },
                      onChangeEnd: (double newLowerValue, double newUpperValue) {
                        print(
                            'Ended with values: $newLowerValue and $newUpperValue');
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("-20 °C"),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Text("40 °C"),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                  Text("Wind", style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20
                  ),),

                  Row(
                    children: <Widget>[
                      Text("Speed", style: TextStyle(
                          fontSize: 16, color: Colors.grey[800]
                      ),)
                    ],
                  ),

                  //wind speed setting
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.blue[700],
                      inactiveTrackColor: Colors.red[300],
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.orange,
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.yellow[700],
                      inactiveTickMarkColor: Colors.red[100],
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.blue,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      value: _windspeed,
                      min: 0,
                      max: 20,
                      divisions: 40,
                      label: '$_windspeed',
                      onChanged: (value) {
                        print(value);
                        setState(
                              () {
                            _windspeed = value;
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("0 mph"),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Text("20 mph"),
                      )
                    ],
                  ),

                  SizedBox(height: 20,),

                  Row(
                    children: <Widget>[
                      Text("Direction", style: TextStyle(
                          fontSize: 16, color: Colors.grey[800]
                      ),)
                    ],
                  ),

                  //wind direction setting
                  DoubleCircularSlider(
                    180,
                    20,
                    40,
                    height: 220.0,
                    width: 220.0,
                    primarySectors: 6,
                    secondarySectors: 24,
                    baseColor: Colors.blue,
                    selectionColor: Colors.red[300],
                    handlerColor: Colors.black,
                    handlerOutterRadius: 12.0,
                    onSelectionChange: _updateLabels,
                    sliderStrokeWidth: 12.0,
                    showHandlerOutter: false,
                    child: Padding(
                      padding: const EdgeInsets.all(42.0),
                      child: Center(
                          child: Text('$startdegree ~ $enddegree °',
                              style: TextStyle(fontSize: 18.0, color: Colors.black))),
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: _checkheavyrain,
                              onChanged: (val){
                                _checkheavyrain = val;
                                setState(() {

                                });
                              },
                            ),
                            Text("Heavy Rain")
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: _checkstorm,
                              onChanged: (val){
                                _checkstorm = val;
                                setState(() {

                                });
                              },
                            ),
                            Text("Storm")
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: _checkheavycloud,
                              onChanged: (val){
                                _checkheavycloud = val;
                                setState(() {

                                });
                              },
                            ),
                            Text("Heavy Cloud")
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                ],
              ),
            ),
          ),
          _isLoading?
          Container(
            color: Colors.grey.withOpacity(0.4),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ):
          Container(),
        ],
      ),

      bottomSheet:  Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          color: Colors.blue[800],
          onPressed: _saveSettings,
          child: Text("Save Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }

  void _initData()async{
    weatherSettings = await getWeatherSettingsLocal();
    if(weatherSettings == null) {
      return;
    }

    _checkheavycloud = weatherSettings.heavyCloud;
    _checkstorm = weatherSettings.storm;
    _checkheavyrain = weatherSettings.heavyRain;
    _lowertemp = weatherSettings.startTemp;
    _uppertemp = weatherSettings.endTemp;
    _windspeed = weatherSettings.windSpeed;
    startdegree = weatherSettings.startWindDirection;
    enddegree = weatherSettings.endWindDirection;
    setState(() {

    });
  }

  void _updateLabels(int start, int end, int middle) {

    setState(() {
      startdegree = start*2;
      enddegree = end*2;
    });
  }


  void _saveSettings()async{
    setState(() {
      _isLoading = true;
    });
    weatherSettings = new WeatherSettings();
     weatherSettings.heavyCloud = _checkheavycloud;
     weatherSettings.storm = _checkstorm;
     weatherSettings.heavyRain = _checkheavyrain;
     weatherSettings.startTemp = _lowertemp;
     weatherSettings.endTemp = _uppertemp;
     weatherSettings.windSpeed = _windspeed;
     weatherSettings.startWindDirection = startdegree;
     weatherSettings.endWindDirection = enddegree;

     await storeWeatherSettingsLocal(weatherSettings);

     LatLng _currentLocation = await getUserLocation();
     if(_currentLocation == null) return;
     bool check = await callWeather(_currentLocation.latitude, _currentLocation.longitude);
     setState(() {
       _isLoading = false;
     });

     if(check)
       Toast.show("Success", context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
     else
       Toast.show("Faild", context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
     return;
  }
}
