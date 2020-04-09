class User {
  String user_id;
  String email;

  User({
    this.user_id,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
      user_id: json["userId"],
      email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "userId": user_id,
    "email": email,
  };
}