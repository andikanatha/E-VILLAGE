import 'dart:convert';

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/LaporModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> postlaporkadesserv({
  required String deskripsi,
  required String image,
  required String tempat_kejadian,
}) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse(baseurl_evillageapi + "/api/user/report/add"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != ""
            ? {
                'image': image,
                'deskripsi': deskripsi,
                'created_date': DateTime.now().toString(),
                'tempat_kejadian': tempat_kejadian
              }
            : {
                'deskripsi': deskripsi,
                'created_date': DateTime.now().toString(),
                'tempat_kejadian': tempat_kejadian
              });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = ModelLapor.fromJson(jsonDecode(response.body));
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
