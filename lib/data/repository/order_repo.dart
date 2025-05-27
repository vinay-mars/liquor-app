import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class OrderRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  OrderRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> createOrder({
    dynamic paymentName,
    dynamic customerId,
    dynamic setPaid,
    dynamic billing,
    dynamic shipping,
    dynamic lineItems,
}) async {
    try {

      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.post(
        AppStrings.createOrderUrl,
        data: {
          "payment_method": paymentName,
          "payment_method_title": paymentName,
          "customer_id": customerId,
          "set_paid": setPaid,
          "billing": {"phone": billing},
          "shipping": shipping,
          "line_items": lineItems,
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

  Future<ApiResponse> getOrderListData() async {
    try {

      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        AppStrings.ordersUrl,
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

  Future<ApiResponse> getOrderDetails({dynamic id}) async {
    try {

      const String username = AppStrings.key;
      const String password = AppStrings.secret;

      // Encode username and password
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      Response response = await dioClient.get(
        "${AppStrings.ordersUrl}$id",
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