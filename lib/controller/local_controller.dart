import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../localization/storage_service.dart';

class LocaleController extends GetxController {
  final storage = Get.find<StorageService>();
  final RxString local = Get.locale.toString().obs;
  final RxString selectedCurrency = ''.obs;
  final box = GetStorage();

  final Map<String, dynamic> optionsLocales = {
    'en': {
      'languageCode': 'en',
      'countryCode': 'US',
      'description': 'English(US)',
    },
    'bn': {
      'languageCode': 'bn',
      'countryCode': 'BD',
      'description': 'Bengali',
    },
    'ar': {
      'languageCode': 'ar',
      'countryCode': 'SA',
      'description': 'Arabic',
    }
    ///Add more Language
  };

  void updateLocale(String key) {
    final String languageCode = optionsLocales[key]['languageCode'];
    final String countryCode = optionsLocales[key]['countryCode'];
    Get.updateLocale(Locale(languageCode, countryCode));
    local.value = Get.locale.toString();
    storage.write("languageCode", languageCode);
    storage.write("countryCode", countryCode);
  }


}