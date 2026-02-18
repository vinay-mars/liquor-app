import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});


  Future<ApiResponse> register(BuildContext context,
      dynamic userName,
      dynamic userEmail,
      dynamic userPassword,) async {
    try {
      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(
          utf8.encode('$username:$password'))}';

      Response response = await dioClient.post(
        AppStrings.registerUrl,
        queryParameters: {
          "username": userName,
          "email": userEmail,
          "password": userPassword,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Authorization': basicAuth,
        }),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login(
      BuildContext context,
      String username,
      String password,
      ) async {
    try {
      final Dio dio = Dio();

      Response response = await dio.post(
        "https://liquor.marsintel.com/wp-json/jwt-auth/v1/token",
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print("✅ LOGIN RESPONSE: ${response.data}");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print("❌ LOGIN ERROR: $e");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> forgetPassword(
      BuildContext context,
      String user,
      ) async {
    try {

      print("user value : $user");
      Response response = await Dio().post(
        "${AppStrings.website}/wp-login.php?action=lostpassword",
        data: {
          "user_login" : user
        },
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data; charset=UTF-8',
            'Accept': 'application/json',
          },
        ),
      );

      // Return successful ApiResponse
      return ApiResponse.withSuccess(response);
    } catch (e) {
      // Return error ApiResponse
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  // for  user token
  Future<void> saveUserToken(String token) async {

    dioClient.updateHeader(token, "");

    try {
      await sharedPreferences.setString(AppStrings.token, token);
      print("========>Token Stored<=======");
      print(await sharedPreferences.getString(AppStrings.token));
    } catch (e) {
      throw e;
    }
  }

  //save user token in local storage
  getUserToken() {
    SharedPreferences.getInstance();
    return sharedPreferences.getString(AppStrings.token) ?? "";
  }

  // remove user token from local storage
  removeUserToken() async{
    await SharedPreferences.getInstance();
    return sharedPreferences.remove(AppStrings.token);

  }

  //auth token
  // for  user token
  Future<void> saveAuthToken(String token) async {
    dioClient.token = token;
    dioClient.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences.setString(AppStrings.token, token);
    } catch (e) {
      throw e;
    }
  }

  String getAuthToken() {
    return sharedPreferences.getString(AppStrings.token) ?? "";
  }


}

