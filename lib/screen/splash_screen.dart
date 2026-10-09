import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pringles_fine_wine/controller/general_setting_controller.dart';
import 'package:pringles_fine_wine/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    final generalSettingController = Get.find<GeneralSettingController>();
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: Stack(
        children: [
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(100.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/pringlesWineLogo.jpeg',
                    height: 65,
                    width: 180,
                  ),
                ),
              ),
            ),
          ),
          Obx(() =>
              generalSettingController.isLoading==false && generalSettingController.generalSettingData!=null?
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  width: double.infinity,
                  child: LinearProgressIndicator(
                  ),
                ),
              ):

              const SizedBox(),
          ),
        ],
      ),
    );
  }
}
