import 'package:saferrider/models/user.dart';
import 'package:saferrider/models/accident.dart';
import 'package:saferrider/models/harzard.dart';
import 'package:saferrider/models/weathersettings.dart';

User current_user;
List<Accident> accidentData = [];
List<Hazard> allHazards = [];
WeatherSettings weatherSettings;

const place_key = "AIzaSyA_YK1Dk-YYLpZJRo-AC-ckfd0lF8vjSwo";

const base_url_of_map = "https://maps.googleapis.com/maps/api/directions/json?alternatives=true&key=AIzaSyA_YK1Dk-YYLpZJRo-AC-ckfd0lF8vjSwo";

const base_url_of_weather = "https://www.metaweather.com/api/location/";
const radius = 100;