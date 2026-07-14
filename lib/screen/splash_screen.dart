import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    return GetBuilder<GeneralSettingController>(
      builder: (generalSettingController) {
        return Scaffold(
          backgroundColor: AppColors.appWhiteColor,
          body: Stack(
            children: [
              Positioned(
                top: 280,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(100.0),
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: [
                    //       const Color(0xff167A52).withValues(alpha: 0.3),
                    //       const Color(0xff167A52),
                    //     ],
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.bottomCenter,
                    //   ),
                    // ),
                    child: Animate(
                      effects: const [FadeEffect(), ScaleEffect()],
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
              ),
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
            ],
          ),
          // bottomNavigationBar: BottomAppBar(
          //   elevation: 0,
          //   color: AppColors.appPrimaryColor,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       // const SizedBox(height: 40),
          //
          //       generalSettingController.isLoading==false && generalSettingController.generalSettingData!=null?
          //       const LinearProgressIndicator():
          //           const SizedBox(),
          //       const SizedBox(height: 16,),
          //       Text("grocery_store".tr
          //
          //         ,style: GoogleFonts.roboto(
          //         fontWeight: FontWeight.w500,
          //         fontSize: 15,
          //         color: AppColors.appWhiteColor,
          //       )),
          //     ],
          //   ),
          // ),
        );
      }
    );
  }
}
