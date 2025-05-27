import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/general_setting_repo.dart';
import '../screen/bottom_navbar.dart';

class GeneralSettingController extends GetxController{

  final GeneralSettingRepo generalSettingRepo;

  GeneralSettingController({required this.generalSettingRepo});

  @override
  void onInit() {
    // TODO: implement onInit
    getGeneralSettingData();
    super.onInit();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final box = GetStorage(); // GetStorage instance

  dynamic generalSettingData;


  Future<dynamic> getGeneralSettingData() async {

    _isLoading = true;
    update();
    ApiResponse apiResponse = await generalSettingRepo.getGeneralSettingData();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        generalSettingData = apiResponse.response!.data!;

        // Find the currency settings
        final currencySetting = generalSettingData.firstWhere((setting) => setting['id'] == 'woocommerce_currency', orElse: () => null);

        if (currencySetting != null) {
          final String currentValue = currencySetting['value'];
          final Map<String, String> options = Map<String, String>.from(currencySetting['options']);

          // Get the currency description
          final currencyDescription = options[currentValue];

          String? currencyValue;

          if (currencyDescription != null) {
            print('Current Currency Code: $currentValue');
            print('Currency Description: $currencyDescription');

             currencyValue = extractCurrencyValue(currencyDescription);

            // Check if currencyValue contains only English characters
            if (containsOnlyEnglishCharacters(currencyValue)) {
              // Try to find another value in parentheses
              currencyValue = extractAlternativeCurrencyValue(currencyDescription);
              print("only english>> $currencyValue");
            }
            else{
              // Extract the currency value
              currencyValue = extractCurrencyValue(currencyDescription);
              print("value>> $currencyValue");
            }
            final String realCurrency = decodeHtml(currencyValue!);

            print('Current Currency Code: $currencyValue');
            print('Real Currency Value: $realCurrency');

            // Store data in GetStorage
            box.write('currency', realCurrency);
            if(realCurrency.isNotEmpty){
              Timer(const Duration(milliseconds: 1000), () {
               Get.offAll(() =>  BottomNavbar(selectedIndex: 0,));
              });
            }

          } else {
            print('Currency code not found in options.');
          }
        } else {
          print('Currency setting not found.');
        }

        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  String? extractCurrencyValue(String description) {
    final RegExp regex = RegExp(r'\((.*?)\)');
    final match = regex.firstMatch(description);
    return match != null ? match.group(1) : '';
  }

  String decodeHtml(String html) {
    // Use the HTML parser to decode entities
    return parse(html).documentElement?.text ?? '';
  }

  bool containsOnlyEnglishCharacters(String? value) {
    if (value == null) return false;
    return RegExp(r'^[a-zA-Z0-9\s]*$').hasMatch(value);
  }

  String? extractAlternativeCurrencyValue(String description) {
    final RegExp regex = RegExp(r'\(([^a-zA-Z\s][^)]*)\)'); // Looks for non-English characters
    final match = regex.firstMatch(description);
    return match != null ? match.group(1) : '';
  }


}