import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class ProductCategoryRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ProductCategoryRepo({required this.dioClient, required this.sharedPreferences});

  /// Get all product category Data
  Future<ApiResponse> getProductCategory() async {
    try {

      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        AppStrings.productCategoriesUrl,
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

  /// Get all product category Data
  Future<ApiResponse> getProductCategoryWiseData(dynamic id,dynamic page) async {
    try {

      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        "${AppStrings.categoryWiseProductUrl}$id&page=$page",
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