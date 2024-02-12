// To parse this JSON data, do
//
//     final admin = adminFromJson(jsonString);

import 'dart:convert';

UserModel adminFromJson(String str) => UserModel.fromJson(json.decode(str));

String adminToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.lastname,
    this.imageUrl,
    this.phone,
    this.email,
    this.password,
    this.token,
  });

  String? id;
  String? name;
  String? lastname;
  String? imageUrl;
  String? phone;
  String? email;
  String? password;
  String? token;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        imageUrl: json["imageUrl"],
        phone: json["phone"],
        email: json["email"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "imageUrl": imageUrl,
        "phone": phone,
        "email": email,
        "token": token,
      };
}
