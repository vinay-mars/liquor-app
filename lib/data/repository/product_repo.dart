import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class ProductRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ProductRepo({required this.dioClient, required this.sharedPreferences});

  /// Get all product Data
  Future<ApiResponse> getProductData({dynamic page}) async {
    try {
      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        "${AppStrings.productUrl}page=$page",
        options: Options(headers: {
          "Content-Type": "application/json",
          'Authorization': basicAuth,
        }),
      );
      log("Responseeeeeeeeeee ${response.data}");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  /// Get all related product Data
  Future<ApiResponse> getAllRelatedProducts({dynamic ids}) async {
    try {
      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        "${AppStrings.relatedProducts}$ids",
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

  /// Get single product Data
  Future<ApiResponse> getProductDetailsData(dynamic id) async {
    try {
      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        "${AppStrings.productDetailsUrl}$id",
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

  Future<ApiResponse> getProductAllVariation({dynamic id}) async {
    try {
      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        "${AppStrings.productDetailsUrl}$id/variations",
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

  Future<ApiResponse> getProductVariationData({dynamic id,dynamic variationId}) async {
    try {
      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        "${AppStrings.productDetailsUrl}$id/variations/$variationId",
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

  createReview(
      {dynamic productId,
      dynamic reviewUserName,
      dynamic reviewUserEmail,
      dynamic reviewText,
      dynamic rating}) async {
    try {
      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.post(
        AppStrings.createReviewUrl,
        data: {
          "product_id": productId,
          "review": reviewText,
          "reviewer": reviewUserName,
          "reviewer_email": reviewUserEmail,
          "rating": rating,
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

  Future<ApiResponse> getAllReviewData(dynamic id) async {
    try {
      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        "${AppStrings.getAllReviewUrl}product=$id",
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
