import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pringles_fine_wine/screen/age_gate_screen.dart';
import 'package:pringles_fine_wine/screen/bottom_navbar.dart';
import 'package:pringles_fine_wine/utils/app_colors.dart';
import 'controller/rtl_controller.dart';
import 'di_container.dart' as di;
import 'localization/app_translation.dart';
import 'localization/storage_service.dart';

dynamic storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Raw exception overlay is for debugging only; release builds keep Flutter's default error widget.
  if (kDebugMode) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Container(
        color: const Color(0xFFFFFF00),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Text(
          details.exceptionAsString(),
          style: const TextStyle(color: Color(0xFF000000), fontSize: 12),
        ),
      );
    };
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  try {
    //init
    await initialConfig();
    //initialize
    storage = Get.find<StorageService>();

    // Initialize the TextDirectionController and load text direction from SharedPreferences
    final rtlController = Get.put(TextDirectionController());
    await rtlController.loadTextDirection();

    await di.init();
    runApp(const MyApp());
  } catch (e, stack) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: kDebugMode
          ? Scaffold(
              backgroundColor: const Color(0xFFFFFF00),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'STARTUP ERROR:\n$e\n\n$stack',
                  style: const TextStyle(color: Color(0xFF000000), fontSize: 11),
                ),
              ),
            )
          : const Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Something went wrong while starting the app.\nPlease close and reopen it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
    ));
  }
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
        home: GetStorage().read('age_verified') == true
            ? BottomNavbar(selectedIndex: 0)
            : const AgeGateScreen(),
        textDirection: textDirectionController.isRTL.value
            ? TextDirection.rtl
            : TextDirection.ltr,
      );
    });
  }
}
