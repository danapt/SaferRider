class Accident {
  double latitude;
  double longitude;


  Accident(
      {
        this.latitude,
        this.longitude,
       });

  Accident.fromJson(Map<String, dynamic> json) {
    latitude = json['Latitude'];
    longitude = json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    return data;
  }
}