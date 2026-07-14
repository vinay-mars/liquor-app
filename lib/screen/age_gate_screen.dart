import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

class AgeGateScreen extends StatefulWidget {
  const AgeGateScreen({super.key});

  @override
  State<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends State<AgeGateScreen> {
  final box = GetStorage();
  bool _underAge = false;

  void _confirmOfAge() {
    box.write('age_verified', true);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.appPrimaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/pringlesWineLogo.jpeg',
                    height: 65,
                    width: 180,
                  ),
                  const SizedBox(height: 40),
                  if (!_underAge) ...[
                    Text(
                      'Age Verification',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: AppColors.appWhiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You must be 21 years of age or older to enter this site.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: AppColors.appWhiteColor,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        height: 50,
                        color: AppColors.appWhiteColor,
                        onPressed: _confirmOfAge,
                        child: Text(
                          "I am 21 or older",
                          style: GoogleFonts.roboto(
                            color: AppColors.appPrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        height: 50,
                        color: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            _underAge = true;
                          });
                        },
                        child: Text(
                          "I am under 21",
                          style: GoogleFonts.roboto(
                            color: AppColors.appWhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Sorry',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: AppColors.appWhiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You must be 21 years of age or older to use this app.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: AppColors.appWhiteColor,
                        fontSize: 15,
                      ),
                    ),
                    if (!kIsWeb && Platform.isAndroid) ...[
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          height: 50,
                          color: AppColors.appWhiteColor,
                          onPressed: () => SystemNavigator.pop(),
                          child: Text(
                            "Close App",
                            style: GoogleFonts.roboto(
                              color: AppColors.appPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
