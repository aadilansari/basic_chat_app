class UserModel {
  final String email;
  final String name;
  final String country;
  final String phone;

  UserModel({
    required this.email,
    required this.name,
    required this.country,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'country': country,
        'phone': phone,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      country: json['country'],
      phone: json['phone'],
    );
  }
}
