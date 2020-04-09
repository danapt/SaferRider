class Hazard {
  String uid;
  double lat;
  double lng;
  String title;
  String image;
  String description;
  String createAt;
  String userId;

  Hazard(
      {this.uid,
        this.lat,
        this.lng,
        this.title,
        this.image,
        this.description,
        this.createAt,
        this.userId});

  Hazard.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    lat = json['lat'];
    lng = json['lng'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    createAt = json['createAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['createAt'] = this.createAt;
    data['userId'] = this.userId;
    return data;
  }
}