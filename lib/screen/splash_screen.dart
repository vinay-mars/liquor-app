import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/general_setting_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';

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
          backgroundColor: AppColors.appPrimaryColor,
          body: Stack(
            children: [
              Positioned(
                child: Opacity(
                  opacity: 0.8,
                  child: Image.asset(
                    "assets/images/splash_image.png",
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 280,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(100.0),
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: [
                    //       const Color(0xff167A52).withOpacity(0.3),
                    //       const Color(0xff167A52),
                    //     ],
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.bottomCenter,
                    //   ),
                    // ),
                    child: Animate(
                      effects: const [FadeEffect(), ScaleEffect()],
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/mars_logo.svg',
                          height: 65,
                          width: 180,
                        ),
                      ),
                    ),

                  ),
                ),
              ),
            ],
          ),
          // bottomNavigationBar: BottomAppBar(
          //   elevation: 0,
          //   color: AppColors.appPrimaryColor,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       generalSettingController.isLoading==false && generalSettingController.generalSettingData!=null?
          //       const LinearProgressIndicator():
          //           const SizedBox(),
          //       // const SizedBox(height: 16,),
          //       // Text("grocery_store".tr
          //
          //       //   ,style: GoogleFonts.roboto(
          //       //   fontWeight: FontWeight.w500,
          //       //   fontSize: 15,
          //       //   color: AppColors.appWhiteColor,
          //       // )
          //
          //         // ,),
          //     ],
          //   ),
          // ),
        );
      }
    );
  }
}
