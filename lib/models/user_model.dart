import 'dart:convert';

class UserModel {
  final int? id;
  final String? username;
  final String? password;
  final String? name;
  final String? lastname;
  final String? birthdayDate;
  final String? email;
  final String? phone;
  final String? address;
  final String? country;
  final DateTime? createdAt;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.name,
    this.lastname,
    this.birthdayDate,
    this.email,
    this.phone,
    this.address,
    this.country,
    this.createdAt,
  });

  UserModel copyWith({
    int? id,
    String? username,
    String? password,
    String? name,
    String? lastname,
    String? birthdayDate,
    String? email,
    String? phone,
    String? address,
    String? country,
    DateTime? createdAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        name: name ?? this.name,
        lastname: lastname ?? this.lastname,
        birthdayDate: birthdayDate ?? this.birthdayDate,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        country: country ?? this.country,
        createdAt: createdAt ?? this.createdAt,
      );

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        name: json["name"],
        lastname: json["lastname"],
        birthdayDate: json["birthday_date"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        country: json["country"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "password": password,
        "name": name,
        "lastname": lastname,
        "birthday_date": birthdayDate,
        "email": email,
        "phone": phone,
        "address": address,
        "country": country,
        "created_at": "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
      };
}
