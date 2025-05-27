import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class ProductSearchRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ProductSearchRepo({required this.dioClient, required this.sharedPreferences});

  /// Get all product Data
  Future<ApiResponse> getProductSearchData({
    dynamic search,
    dynamic category,
    dynamic minPrice,
    dynamic maxPrice,
    dynamic page,
  }) async {
    try {
      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      // Convert null values to empty strings
      final String safeSearch = search?.toString() ?? '';
      final String safeCategory = category?.toString() ?? '';
      final String safeMinPrice = minPrice?.toString() ?? '';
      final String safeMaxPrice = maxPrice?.toString() ?? '';
      final String safePage = page?.toString() ?? '';

      // Construct URL with encoded parameters

      dynamic url;

      if(category!=null && search==null){
        url = "${AppStrings.productUrl}category=$safeCategory&min_price=$safeMinPrice&max_price=$safeMaxPrice&page=$safePage";
      }
      else{
        url = "${AppStrings.productUrl}search=$safeSearch&category=$safeCategory&min_price=$safeMinPrice&max_price=$safeMaxPrice&page=$safePage";
      }


      Response response = await dioClient.get(
        url,
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
