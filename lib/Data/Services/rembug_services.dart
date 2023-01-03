//userdetail
import 'dart:convert';

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/RembugModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getallrembug() async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .get(Uri.parse(baseurl_evillageapi + "/api/user/rembug"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = RembugData.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiresponse.error = unauthroized;
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

//Post
Future<ApiResponse> postrembug({
  required String deskripsi,
  required String image,
}) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse(baseurl_evillageapi + "/api/user/rembug/add"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != ""
            ? {
                'image': image,
                'deskripsi': deskripsi,
                'created_date': DateTime.now().toString()
              }
            : {
                'deskripsi': deskripsi,
                'created_date': DateTime.now().toString()
              });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = RembugData.fromJson(jsonDecode(response.body));
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
