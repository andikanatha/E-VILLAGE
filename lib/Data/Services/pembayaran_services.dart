import 'dart:convert';

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/PembayaranModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:http/http.dart' as http;

//Pembayaran
Future<ApiResponse> pembayaran({
  required String name,
  required String keterangan,
  required String transactiontotal,
}) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse(baseurl_evillageapi + "/api/user/transaksi/pembayaran"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'trx_name': 'Pembayaran ' + name,
          'description': keterangan,
          'total_trx': transactiontotal,
          'created_at': DateTime.now().toString()
        });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = PembayaranModel.fromJson(jsonDecode(response.body));
        break;
      case 403:
        apiresponse.error = jsonDecode(response.body)['message'];
        break;

      default:
        apiresponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }
  return apiresponse;
}
