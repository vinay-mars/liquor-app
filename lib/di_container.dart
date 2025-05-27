import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/general_setting_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/product_search_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/rtl_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/data/repository/general_setting_repo.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/data/repository/product_search_repo.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_strings.dart';
import 'controller/auth_controller.dart';
import 'controller/cart_controller.dart';
import 'controller/local_controller.dart';
import 'controller/order_controller.dart';
import 'controller/product_category_controller.dart';
import 'controller/product_controller.dart';
import 'controller/profile_controller.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repository/auth_repo.dart';
import 'data/repository/order_repo.dart';
import 'data/repository/product_category_repo.dart';
import 'data/repository/product_repo.dart';
import 'data/repository/profile_repo.dart';


final sl = GetIt.instance;

Future<void> init() async {
  /// Core
   sl.registerLazySingleton(() => DioClient(AppStrings.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

   log("----------------------- AppStrings ${AppStrings.baseUrl}");
  ///Repository
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProductCategoryRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProductSearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => GeneralSettingRepo(dioClient: sl(), sharedPreferences: sl()));


  /// Controller
  Get.lazyPut(() =>  AuthController(authRepo: sl(), dioClient: sl()), fenix: true);
  Get.lazyPut(() =>  ProfileController(profileRepo: sl()), fenix: true);
  Get.lazyPut(() =>  ProductController(productRepo: sl()), fenix: true);
  Get.lazyPut(() =>  ProductSearchController(productSearchRepo: sl()), fenix: true);
  Get.lazyPut(() =>  ProductCategoryController(productCategoryRepo: sl()), fenix: true);
  Get.lazyPut(() =>  GeneralSettingController(generalSettingRepo: sl()), fenix: true);
  Get.lazyPut(() =>  OrderController(orderRepo: sl()), fenix: true);
  Get.lazyPut(() =>  CartController(),fenix: true);
  Get.lazyPut(() => LocaleController(), fenix: true);
  Get.lazyPut(() => TextDirectionController(), fenix: true);



  /// External pocket lock
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}