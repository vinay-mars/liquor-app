import 'package:dio/dio.dart';
import '../../../model/base_model/error_response.dart';

class ApiErrorHandler {
  static String getMessage(dynamic error) {
    String errorDescription = "Unexpected error occurred";

    if (error is DioException) {
      try {
        switch (error.type) {
          case DioExceptionType.cancel:
            errorDescription = "Request to server was cancelled";
            break;
          case DioExceptionType.connectionTimeout:
            errorDescription = "Connection timeout with server";
            break;
          case DioExceptionType.receiveTimeout:
            errorDescription = "Receive timeout in connection with server";
            break;
          case DioExceptionType.sendTimeout:
            errorDescription = "Send timeout with server";
            break;
          case DioExceptionType.unknown:
            errorDescription = "Connection to server failed due to internet connection";
            break;
          case DioExceptionType.badResponse:
            if (error.response != null) {
              switch (error.response!.statusCode) {
                case 404:
                  errorDescription = "Resource not found";
                  break;
                case 500:
                  errorDescription = "Internal server error";
                  break;
                case 503:
                  errorDescription = "Service unavailable";
                  break;
                case 429:
                  errorDescription = "Too many requests";
                  break;
                default:
                // Handle cases where the error response has a specific message
                  ErrorResponse errorResponse = ErrorResponse.fromJson(error.response!.data);
                  if (errorResponse.error != null) {

                  } else {
                    errorDescription = "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
            } else {
              errorDescription = "Failed to load data - no response";
            }
            break;
          default:
            errorDescription = "An unknown error occurred";
        }
      } on FormatException catch (e) {
        errorDescription = "Formatting error: ${e.message}";
      }
    } else {
      errorDescription = "Non-DioException error: ${error.toString()}";
    }
    return errorDescription;
  }
}
