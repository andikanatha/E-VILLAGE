// ignore_for_file: non_constant_identifier_names, file_names, unused_import

import 'dart:ffi';

import 'package:flutter/foundation.dart';

class DetailTrx {
  int? id;
  String? trx_name;
  String? trx_date;
  String? seconduser;
  String? datefor;
  String? status;
  String? total_trx;
  String? description;
  String? nameuser;

  DetailTrx(
      {this.id,
      this.trx_name,
      this.trx_date,
      this.seconduser,
      this.datefor,
      this.status,
      this.total_trx,
      this.description,
      this.nameuser});

  factory DetailTrx.fromJson(Map<String, dynamic> json) {
    return DetailTrx(
      id: json['id'],
      trx_name: json['trx_name'],
      trx_date: json['trx_date'],
      seconduser: json['seconduser'],
      datefor: json['datefor'],
      status: json['status'],
      total_trx: json['total_trx'],
      description: json['description'],
      nameuser: json['users']['name'],
    );
  }
}
