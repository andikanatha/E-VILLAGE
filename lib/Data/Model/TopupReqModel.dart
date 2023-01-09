// ignore_for_file: non_constant_identifier_names, file_names, unused_import

import 'dart:ffi';

import 'package:flutter/foundation.dart';

class TopupsaldoModel {
  int? id;
  String? status;
  String? description;
  String? nominal;
  String? topup_date;
  int? id_user;
  int? seconduser;

  TopupsaldoModel(
      {this.id,
      this.description,
      this.nominal,
      this.id_user,
      this.seconduser,
      this.status,
      this.topup_date});

  factory TopupsaldoModel.fromJson(Map<String, dynamic> json) {
    return TopupsaldoModel(
        id: json['Transaction']['id'],
        description: json['Transaction']['description'],
        nominal: json['Transaction']['nominal'],
        id_user: json['Transaction']['id_user'],
        seconduser: json['Transaction']['seconduser'],
        status: json['Transaction']['status'],
        topup_date: json['Transaction']['topup_date']);
  }
}
