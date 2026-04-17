import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class ProfileRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getProfileData() async {
    try {

      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      SharedPreferences preferences = await SharedPreferences.getInstance();
      dynamic customerId = preferences.getInt("customerId");

      print("check Id >>> ${customerId}");

      Response response = await dioClient.get(
        "${AppStrings.profileUrl}$customerId",
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


  Future<ApiResponse> updateProfileData({dynamic firstName, dynamic lastName, dynamic email, dynamic phone}) async {
    try {

      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      SharedPreferences preferences = await SharedPreferences.getInstance();
      dynamic customerId = preferences.getInt("customerId");

      print("check Id >>> ${customerId}");

      Response response = await dioClient.put(
        "${AppStrings.profileUrl}$customerId",
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "billing": {
            "phone": phone,
          }
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

  Future<ApiResponse> updateShippingAddress({
    dynamic firstName,
    dynamic lastName,
    dynamic address1,
    dynamic address2,
    dynamic city,
    dynamic postCode,
    dynamic state,
    dynamic phone,
  }) async {
    try {

      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      SharedPreferences preferences = await SharedPreferences.getInstance();
      dynamic customerId = preferences.getInt("customerId");

      print("check Id >>> ${customerId}");

      Response response = await dioClient.put(
        "${AppStrings.profileUrl}$customerId",
        data: {
          "billing": {
            "phone": phone,
            "first_name": firstName,
            "last_name": lastName,
            "address_1": address1,
            "address_2": address2,
            "city": city,
            "state": state,
            "postcode": postCode,
          },
          "shipping": {
            "first_name": firstName,
            "last_name": lastName,
            "address_1": address1,
            "address_2": address2,
            "city": city,
            "state": state,
            "postcode": postCode,
          }
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

  Future<ApiResponse> deleteUser() async {
    try {

      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      SharedPreferences preferences = await SharedPreferences.getInstance();
      dynamic customerId = preferences.getInt("customerId");

      print("check Id >>> ${customerId}");

      Response response = await dioClient.delete(
        "https://www.radiustheme.com/demo/wordpress/themes/autonex/wp-json/wc/v3/customers/$customerId",
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


}