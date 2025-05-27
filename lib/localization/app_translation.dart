import 'package:get/get.dart';
import 'language/arabic.dart';
import 'language/bengali.dart';
import 'language/english.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar_SA': _convertToStringMap(arabic),
    'bn_BD': _convertToStringMap(bengali),
    'en_US': _convertToStringMap(english),
    // Add more languages here as needed
  };

  // Convert dynamic map to String map
  Map<String, String> _convertToStringMap(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, value.toString()));
  }
}