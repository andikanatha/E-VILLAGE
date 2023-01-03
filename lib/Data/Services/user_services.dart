// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';

import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:http/http.dart' as http;

//LoginFunction
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> login(
    {required String email, required String password}) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    final response = await http.post(
        Uri.parse(baseurl_evillageapi + "/api/login"),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});

    switch (response.statusCode) {
      case 200:
        apiresponse.data = UserModel.fromJson(jsonDecode(response.body));
        break;
      case 422:
        apiresponse.error = "email invalid";
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

//RegisterFunction
Future<ApiResponse> registerUser(
    {required String name,
    required String username,
    required String email,
    required String password}) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    final response = await http
        .post(Uri.parse(baseurl_evillageapi + "/api/user/register"), headers: {
      'Accept': 'application/json'
    }, body: {
      'username': username,
      'name': name,
      'email': email,
      'password': password,
    });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = UserModel.fromJson(jsonDecode(response.body));
        break;
      case 422:
        apiresponse.error = alreadyemailuse;
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

//GetToken
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

//GetUserid
Future<int> getUserid() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

//GetUserrole
Future<String> getUserrole() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('role') ?? "";
}

//LOGOUT
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.remove('token');
}

//userdetail
Future<ApiResponse> getuserdetail() async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .get(Uri.parse(baseurl_evillageapi + "/api/user"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiresponse.data = UserModel.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiresponse.error = unauthroized;
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }
  return apiresponse;
}

// Update Image User
Future<ApiResponse> updateimg({
  required String? image_profile,
}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .put(Uri.parse(baseurl_evillageapi + "/api/user/update/img"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'image_user': image_profile,
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthroized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Update Image User
Future<ApiResponse> updateuser({required String? name}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .put(Uri.parse(baseurl_evillageapi + "/api/user/update"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'name': name,
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthroized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Update Username
Future<ApiResponse> updateusername({String? username}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse(baseurl_evillageapi + "/api/user/update/username"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'username': username
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthroized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Topup User
Future<ApiResponse> usertopup({required String? saldotopup}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .put(Uri.parse(baseurl_evillageapi + "/api/user/topup"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'saldo': saldotopup
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthroized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
