import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/splash_screen.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';
import 'controller/rtl_controller.dart';
import 'di_container.dart' as di;
import 'localization/app_translation.dart';
import 'localization/storage_service.dart';

dynamic storage;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //Assign publishable key to flutter_stripe
  Stripe.publishableKey = "pk_test_51PvDHTEKi0iQdDNFYuqPLpjVjvlHOQOTENx7RvLUPWcY1zsSUrnBvVV5kxKs1Zt50LFZAmy0vN5yKH3YY5yc5R4t00L0QDyvoM";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");

  //init
  await initialConfig();
  //initialize
  storage = Get.find<StorageService>();

  // Initialize the TextDirectionController and load text direction from SharedPreferences
  final rtlController = Get.put(TextDirectionController());
  await rtlController.loadTextDirection();

  await di.init();
  runApp(const MyApp());
}

initialConfig() async {
  await Get.putAsync(() => StorageService().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TextDirectionController>(
      builder: (textDirectionController) {
        return GetMaterialApp(
          translations: AppTranslations(),
          locale: storage.languageCode != null
              ? Locale(storage.languageCode!, storage.countryCode)
              : const Locale("en", "US"),
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          title: 'Zilly - Grocery Store',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appPrimaryColor),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          textDirection: textDirectionController.isRTL.value ? TextDirection.rtl : TextDirection.ltr,
        );
      }
    );
  }
}

