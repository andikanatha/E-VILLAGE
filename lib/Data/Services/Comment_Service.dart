import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Pembayaran
Future<ApiResponse> commentpost({
  required String idpost,
  required String comment,
}) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse(
            baseurl_evillageapi + "/api/user/rembug/comment/add/" + idpost),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'comment': comment,
          'commentdate': DateTime.now().toString(),
        });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['message'];
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

Future<ApiResponse> deletecommentt({
  required String id,
}) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse(baseurl_evillageapi + "/api/user/rembug/comment/delete/" + id),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['message'];
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

Future<ApiResponse> updatecommentt({
  required String id,
  required String comment,
}) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse(
            baseurl_evillageapi + "/api/user/rembug/comment/update/" + id),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'comment': comment,
        });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['message'];
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
