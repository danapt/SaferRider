class WeatherSettings {
  double startTemp;
  double endTemp;
  double windSpeed;
  int startWindDirection;
  int endWindDirection;
  bool heavyRain;
  bool storm;
  bool heavyCloud;

  WeatherSettings(
      {this.startTemp,
        this.endTemp,
        this.windSpeed,
        this.startWindDirection,
        this.endWindDirection,
        this.heavyRain,
        this.storm,
        this.heavyCloud});

  WeatherSettings.fromJson(Map<String, dynamic> json) {
    startTemp = json['startTemp'];
    endTemp = json['endTemp'];
    windSpeed = json['windSpeed'];
    startWindDirection = json['startWindDirection'];
    endWindDirection = json['endWindDirection'];
    heavyRain = json['heavyRain'];
    storm = json['storm'];
    heavyCloud = json['heavyCloud'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTemp'] = this.startTemp;
    data['endTemp'] = this.endTemp;
    data['windSpeed'] = this.windSpeed;
    data['startWindDirection'] = this.startWindDirection;
    data['endWindDirection'] = this.endWindDirection;
    data['heavyRain'] = this.heavyRain;
    data['storm'] = this.storm;
    data['heavyCloud'] = this.heavyCloud;
    return data;
  }
}