// ignore_for_file: non_constant_identifier_names, file_names, unused_import

import 'dart:ffi';

import 'package:flutter/foundation.dart';

class UserModel {
  int? id;
  String? image_user;
  String? name;
  String? username;
  String? email;
  String? akses;
  dynamic saldo;
  String? token;
  String? pin;

  UserModel(
      {this.id,
      this.image_user,
      this.name,
      this.username,
      this.email,
      this.akses,
      this.saldo,
      this.pin,
      this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['user']['id'],
        image_user: json['user']['image_user'],
        name: json['user']['name'],
        username: json['user']['username'],
        email: json['user']['email'],
        akses: json['user']['akses'],
        pin: json['user']['pin'],
        saldo: json['user']['saldo'],

        //TOKEN
        token: json['token']);
  }
}
