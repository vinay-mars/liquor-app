import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pringles_fine_wine/screen/splash_screen.dart';
import 'package:pringles_fine_wine/utils/app_colors.dart';
import 'controller/rtl_controller.dart';
import 'di_container.dart' as di;
import 'localization/app_translation.dart';
import 'localization/storage_service.dart';

dynamic storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        title: 'Pringles Fine Wine',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: AppColors.appPrimaryColor),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        textDirection: textDirectionController.isRTL.value
            ? TextDirection.rtl
            : TextDirection.ltr,
      );
    });
  }
}
