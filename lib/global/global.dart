import 'package:saferrider/models/user.dart';
import 'package:saferrider/models/accident.dart';
import 'package:saferrider/models/harzard.dart';
import 'package:saferrider/models/weathersettings.dart';

User current_user;
List<Accident> accidentData = [];
List<Hazard> allHazards = [];
WeatherSettings weatherSettings;

const place_key = "AIzaSyDhk7hyvXPqgWpzDrsUMFoYbec_uzatg0w";
const base_url_of_here = "https://route.ls.hereapi.com/routing/7.2/calculateroute.json?apiKey=TYKKAI2u4mx2-njqUiyfIzy4qr54eahGJa_ekxYiVn8&"
    "departure=now&mode=fastest;publicTransport&alternatives=5";

const base_url_of_map = "https://maps.googleapis.com/maps/api/directions/json?alternatives=true&key=AIzaSyC5SfKBN7YPJ323CJYBfSYnjBSbpiz9qCI";

const base_url_of_weather = "https://www.metaweather.com/api/location/";
const radius = 100;