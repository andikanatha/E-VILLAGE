// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

const baseurl_evillageapi = "http://192.168.1.8:8000";

const serverError = 'Mohon maaf!, server sedang bermasalah';
const somethingWentWrong = 'Ada Kesalahan!, cek kembali jaringan kamu';
const unauthroized = 'Mohon login terlebih dahulu!';
const alreadyemailuse = 'Email telah digunakan';

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}

class Idrcvt {
  static String convertToIdr(
      {required dynamic count, required int decimalDigit}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(count);
  }
}
