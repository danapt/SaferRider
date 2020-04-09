import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saferrider/models/weathersettings.dart';
import 'package:saferrider/models/weather.dart';
import 'localNotificationHelper.dart';
import 'package:saferrider/global/global.dart';
import 'dart:convert';

Future<String> storeWeatherSettingsLocal(WeatherSettings _settings) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String data = json.encode(_settings.toJson());
  await prefs.setString('weathersettings', data);
}

Future<WeatherSettings> getWeatherSettingsLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('weathersettings') != null) {
    print(prefs.getString('weathersettings'));
    WeatherSettings weathersettings = WeatherSettings.fromJson(json.decode(prefs.getString('weathersettings')));
    return weathersettings;
  } else {
    return null;
  }
}

Future<bool> callWeather(double lat,double lng)async{
  List<Weather> _weathers = [];
  _weathers = await _getWeather(lat, lng);
  if(_weathers.isEmpty) return false;
  DateTime _currentDate = DateTime.now();
  print(_currentDate);
  await LocalNotificationHelper().clearNotification();

  int i = 0;
  for(var item in _weathers){
    i++;
    String notificationTitle = "Weather Alert!";
    String notificationBody = "";
    print(item.applicableDate);
    DateTime _date = DateTime.parse(item.applicableDate);
    int difference = _date.difference(_currentDate).inMinutes;
    print(difference);
    print(_date);
    if(difference <= 0){
      difference = 1;
    }

    notificationBody = checkWeather(item);
    if(notificationBody == ""){
      continue;
    }

    await LocalNotificationHelper().setNotification(i, notificationTitle, notificationBody, difference);
  }

  return true;
}

Future<List<Weather>> _getWeather(double lat, double lng)async{
  List<Weather> _weathers = [];
  String _location_url = base_url_of_weather + "search/?lattlong=$lat, $lng";
  print("THIS IS NOT WORKING "+_location_url);
  try{
    var response = await http.get(_location_url);

    List data = json.decode(response.body);
    if(data == null) return null;
    int _locationId = data[0]['woeid'];
    print(_locationId);
    String _getweatherurl = base_url_of_weather + "$_locationId";
    var weatherresponse = await http.get(_getweatherurl);
    Map weatherdata = json.decode(weatherresponse.body);
    List _weatherList = weatherdata['consolidated_weather'];
    for(var item in _weatherList){
      _weathers.add(new Weather.fromJson(item));
    }

  }catch(e){
    print(e.toString());
  }

  return _weathers;
}


String checkWeather(Weather _weather){
  String message= "";
  if(weatherSettings.heavyCloud&&_weather.weatherStateName == "Heavy Cloud"){
    message += "Heavy Cloud";
  }

  if(weatherSettings.heavyRain&&_weather.weatherStateName == "Heavy Rain"){
    message += "Heavy Rain";
  }

  if(weatherSettings.storm&&_weather.weatherStateName == "Storm"){
    message += "Storm";
  }

  if(weatherSettings.startTemp >= _weather.minTemp || weatherSettings.endTemp <= _weather.maxTemp){
    message += " Temp:${_weather.minTemp.round()}, ${_weather.maxTemp.round()} °C";
  }

  if(weatherSettings.windSpeed <= _weather.windSpeed){
    message += " Wind:${_weather.windSpeed.round()} mph";
  }

  if(_weather.windDirection >= weatherSettings.startWindDirection && _weather.windDirection <= weatherSettings.endWindDirection){
    print("direction");
    message += ", ${_weather.windDirection.round()} degree";
  }

  print(message);
  return message;
}