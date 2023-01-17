import 'dart:convert';

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/PembayaranDetailModel.dart';
import 'package:e_villlage/Data/Model/PembayaranModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:http/http.dart' as http;

//Pembayaran
Future<ApiResponse> pembayaran({
  required String name,
  required String keterangan,
  required String datefor,
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
          'trx_date': DateTime.now().toString(),
          'datefor': datefor
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

//Transfer
Future<ApiResponse> transfer({
  required String seconduser,
  required String keterangan,
  required String transactiontotal,
}) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse(baseurl_evillageapi + "/api/user/transaksi/transfer"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'name_second_user': seconduser,
          'description': keterangan,
          'total_trx': transactiontotal,
          'trx_date': DateTime.now().toString(),
        });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['massage'];
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

//userdetail
Future<ApiResponse> getdetailtrx({required String id}) async {
  ApiResponse apiresponse = ApiResponse();

  String token = await getToken();
  final response = await http.get(
      Uri.parse(baseurl_evillageapi + "/api/user/transaksi/detail/" + id),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
  apiresponse.data = DetailTrx.fromJson(jsonDecode(response.body));

  return apiresponse;
}
