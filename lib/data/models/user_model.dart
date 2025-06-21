class UserModel {
  final String email;
  final String name;
  final String country;
  final String phone;
  final String fcmToken;
  final String? password;

  UserModel({
    required this.email,
    required this.name,
    required this.country,
    required this.phone,
    required this.fcmToken,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'country': country,
        'phone': phone,
        'fcmToken': fcmToken,
        'password': password,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      country: json['country'],
      phone: json['phone'],
      fcmToken: json['fcmToken'],
      password: json['password'],
    );
  }

  UserModel copyWith({
    String? email,
    String? name,
    String? country,
    String? phone,
    String? fcmToken,
    String? password,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      fcmToken: fcmToken ?? this.fcmToken,
      password: password ?? this.password,
    );
  }
}
