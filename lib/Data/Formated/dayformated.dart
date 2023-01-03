import 'package:intl/intl.dart';

String formatdayIndo({required String date}) {
  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);

  var day = DateFormat('EEEE').format(dateTime);
  var hari = "";

  switch (day) {
    case 'Sunday':
      {
        hari = "Minggu";
      }
      break;
    case 'Monday':
      {
        hari = "Senin";
      }
      break;
    case 'Tuesday':
      {
        hari = "Selasa";
      }
      break;
    case 'Wednesday':
      {
        hari = "Rabu";
      }
      break;
    case 'Thursday':
      {
        hari = "Kamis";
      }
      break;
    case 'Friday':
      {
        hari = "Jumat";
      }
      break;
    case 'Saturday':
      {
        hari = "Sabtu";
      }
      break;
  }
  return hari;
}

int daykmrin({required String date}) {
  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);

  String day = DateFormat('dd').format(dateTime);
  int dayint = int.parse(day);
  int dayresult = dayint + 1;

  return dayresult;
}

String formatJamIndo({required String date}) {
  if (date != "") {
    DateTime dt = DateTime.parse(date);
    String jam = DateFormat('HH:mm').format(dt);

    return '$jam';
  } else {
    return "- : -";
  }
}

String formatTglIndo({required String date}) {
  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);

  var m = DateFormat('MM').format(dateTime);
  var d = DateFormat('dd').format(dateTime).toString();
  var Y = DateFormat('yyyy').format(dateTime).toString();
  var month = "";
  switch (m) {
    case '01':
      {
        month = "Januari";
      }
      break;
    case '02':
      {
        month = "Februari";
      }
      break;
    case '03':
      {
        month = "Maret";
      }
      break;
    case '04':
      {
        month = "April";
      }
      break;
    case '05':
      {
        month = "Mei";
      }
      break;
    case '06':
      {
        month = "Juni";
      }
      break;
    case '07':
      {
        month = "Juli";
      }
      break;
    case '08':
      {
        month = "Agustus";
      }
      break;
    case '09':
      {
        month = "September";
      }
      break;
    case '10':
      {
        month = "Oktober";
      }
      break;
    case '11':
      {
        month = "November";
      }
      break;
    case '12':
      {
        month = "Desember";
      }
      break;
  }
  return "$d $month $Y";
}

String formatBulanIndo({required String date}) {
  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);

  var m = DateFormat('MM').format(dateTime);
  var Y = DateFormat('yyyy').format(dateTime).toString();
  var month = "";
  switch (m) {
    case '01':
      {
        month = "Januari";
      }
      break;
    case '02':
      {
        month = "Februari";
      }
      break;
    case '03':
      {
        month = "Maret";
      }
      break;
    case '04':
      {
        month = "April";
      }
      break;
    case '05':
      {
        month = "Mei";
      }
      break;
    case '06':
      {
        month = "Juni";
      }
      break;
    case '07':
      {
        month = "Juli";
      }
      break;
    case '08':
      {
        month = "Agustus";
      }
      break;
    case '09':
      {
        month = "September";
      }
      break;
    case '10':
      {
        month = "Oktober";
      }
      break;
    case '11':
      {
        month = "November";
      }
      break;
    case '12':
      {
        month = "Desember";
      }
      break;
  }
  return "$month $Y";
}
