import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasource/remote/dio/dio_client.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/auth_repo.dart';
import '../screen/bottom_navbar.dart';
import '../screen/login_screen.dart';

class AuthController extends GetxController{
  DioClient dioClient;
  final AuthRepo authRepo;
  AuthController({required this.authRepo,required this.dioClient});

  bool isLoadingLogin = false;
  bool isLoadingForget = false;
  bool isLoadingRegister = false;

  var isLoginPasswordVisible = false.obs;
  var isRegisterPasswordVisible = false.obs;
  var isRegisterConfirmPasswordVisible = false.obs;

  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
    update();
  }

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordVisible.value = !isRegisterPasswordVisible.value;
    update();
  }

  void toggleRegisterConfirmPasswordVisibility() {
    isRegisterConfirmPasswordVisible.value = !isRegisterConfirmPasswordVisible.value;
    update();
  }

  Future<dynamic> register(
      BuildContext context,
      dynamic userName,
      dynamic email,
      dynamic password,
      ) async {
    try {
      isLoadingRegister = true;
      update();

      ApiResponse apiResponse = await authRepo.register(
        context,
        userName,
        email,
        password,
      );

      if (apiResponse.response != null && apiResponse.response!.statusCode == 201) {
        Fluttertoast.showToast(
            msg: "Account created successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Map map = apiResponse.response!.data;
        dynamic customerId = map["id"];
        print("customer id : $customerId");
        if (customerId != null) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setInt("customerId", customerId);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.to(() => LoginScreen(selectedIndex: 0,));
          });
        } else {
          if (kDebugMode) {
            print("Status code is not 201");
          }
        }
      } else if (apiResponse.response != null && apiResponse.response!.statusCode == 400) {
        print("Status code is 400");
        print("Response data: ${apiResponse.response!.data}");

        Fluttertoast.showToast(
          msg: apiResponse.response!.data["message"] ?? "Bad request",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

    } catch (e) {
      if (kDebugMode) {
        print("Error:::: $e:::::=> Username :: $userName => $email => $password");
      }
      Fluttertoast.showToast(
          msg: "Failed! Something wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      isLoadingRegister = false;
      update();
    }
  }

  Future<dynamic> login(
      BuildContext context,
      dynamic userName,
      dynamic password,
      dynamic selectedIndex,
      ) async {
    isLoadingLogin = true;
    update();

    ApiResponse apiResponse;
    try {
      apiResponse = await authRepo.login(context, userName, password);


      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        Map map = apiResponse.response!.data;
        dynamic token = map["token"];
        dynamic customerId;


        if (token != null && token.isNotEmpty) {
          if (JwtDecoder.isExpired(token)) {
            print('Token is expired');
            return null;
          }
          // Decode the token
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          if (kDebugMode) {
            print("decode token>>>$decodedToken");
          }

          // Extract user ID from the payload (assuming the user ID is stored under the key 'user_id')
          customerId = int.parse(decodedToken['data']['user']['id']);
          if (kDebugMode) {
            print('Customer id is>>>>$customerId');
          }

          if (customerId != null) {
            authRepo.saveUserToken(token);
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.setString("token", token);
            preferences.setInt("customerId", customerId);
            preferences.setString("email_id", apiResponse.response!.data["user_email"]);
            preferences.setString("user_display_name", apiResponse.response!.data["user_display_name"]);
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.to(() =>  BottomNavbar(selectedIndex: selectedIndex,));
            Fluttertoast.showToast(
                msg: "Login Successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0
            );
            update();
          });


        }
      }
      else {
        if (apiResponse.response != null && apiResponse.response!.statusCode != 200) {
          print("Reponseeeeeeeeeeeeeeeeeeeeeeee ${response}");

        }
          if (kDebugMode) {
          print("Status code is not 200");
        }

        Fluttertoast.showToast(
            msg: "Login Failed! Something wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      if (kDebugMode) {
        print("An error occurred during login");
      }
    } finally {
      isLoadingLogin = false;
      update();
    }

  }


  dynamic response;

  Future<dynamic> forgetPassword(
      BuildContext context,
      dynamic user,
      ) async {
    isLoadingForget = true;
    update();

    ApiResponse apiResponse;
    try {
      apiResponse = await authRepo.forgetPassword(context, user);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        isLoadingForget =false;
        print("api calling...");
        response = apiResponse.response!.data;
        print("$response");
        update();
        return apiResponse.response!.statusCode;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      if (kDebugMode) {
        print("An error occurred during login");
      }

    } finally {
      isLoadingForget = false;
      update();
    }

  }


  // for user Section
  dynamic getUserToken(){
    update();
    if (kDebugMode) {
      print(authRepo.getUserToken());
    }
    return authRepo.getUserToken();
  }

  // remove user Section
  void removeUserToken(){
    update();
    if (kDebugMode) {
      print("remove");
    }
    authRepo.removeUserToken();
  }

  //get auth token
  // for user Section
  String getAuthToken() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
      dioClient.updateHeader(authRepo.getAuthToken(), '');
    });
    return authRepo.getAuthToken();
  }

}