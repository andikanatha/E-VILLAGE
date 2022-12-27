// Get base64 encoded image
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

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
