import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/bottom_navbar.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/forget_password_screen.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/home_screen.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/register_screen.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  dynamic selectedIndex;
  LoginScreen({super.key,this.selectedIndex});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool obSecureText = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return;
            }
            showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Dialog Content
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'exit'.tr,
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'sure_exit'.tr,
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black54, // Color for the Cancel button
                                    ),
                                    onPressed: () {
                                      Get.back(); // Do not exit
                                    },
                                    child: Text(
                                      'cancel'.tr,
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: AppColors.appWhiteColor
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.appPrimaryColor, // Primary color for the Exit button
                                    ),
                                    onPressed: () {
                                      SystemNavigator.pop(); // Exit the app
                                    },
                                    child: Text(
                                      'exit'.tr,
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: Colors.white, // Text color for the Exit button
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                        height: 220,
                        color: AppColors.appWhiteColor,
                      ),
                        Opacity(
                            opacity: 0.4,
                            child: Image.asset("assets/images/splash_bg.png",fit: BoxFit.cover,width: double.infinity,)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
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
                                child:  Image.asset(
                                  'assets/images/liquorlylogo.png',height: 60,width: 180,)),
                          ),
                        ),


                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // soft shadow
                          blurRadius: 8, // how soft the shadow is
                          offset: const Offset(0, 0), // Shadow evenly around the container
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,right: 16,top: 24
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text("sign_in".tr,style: GoogleFonts.roboto(
                              color: AppColors.appBlackColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),),

                          Text("welcome_back".tr,style: GoogleFonts.roboto(
                              color: AppColors.appWelcomeBackTxtColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                          ),),

                          const SizedBox(height: 45,),

                          Text("email".tr,style: GoogleFonts.roboto(
                              color: AppColors.appBlackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),),

                          const SizedBox(height: 8,),

                          // Username TextField
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.appTextFieldFillColor,
                                hintText: "type_email".tr,
                                hintStyle: GoogleFonts.roboto(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: AppColors.appTextFieldHintColor
                                ),
                                border: InputBorder.none
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 22),

                          Text("password".tr,style: GoogleFonts.roboto(
                              color: AppColors.appBlackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),),

                          const SizedBox(height: 8,),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      obSecureText = !obSecureText;
                                    });
                                  },
                                  child:  Icon(obSecureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,color:AppColors.appWelcomeBackTxtColor,)),
                              filled: true,
                              fillColor: AppColors.appTextFieldFillColor,
                              hintText: "type_password".tr,
                              hintStyle: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: AppColors.appTextFieldHintColor
                              ),
                              border: InputBorder.none,
                            ),
                            obscureText: obSecureText,
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.to(()=> ForgetPasswordScreen());
                                },
                                child: Text("Forgot Password?",style: GoogleFonts.roboto(
                                    color: AppColors.appPrimaryColor,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationColor: AppColors.appPrimaryColor
                                ),),
                              )
                            ],
                          ),

                          const SizedBox(height: 45),
                          // Login Button
                          authController.isLoadingLogin==false?
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: MaterialButton(
                                color: AppColors.appPrimaryColor,
                                onPressed: () {
                                  authController.login(
                                      context,
                                      _usernameController.text.toString(),
                                      _passwordController.text.toString(),
                                       widget.selectedIndex
                                  );
                                },
                                height: 45,
                                minWidth: double.infinity,
                                child: Text('login'.tr,style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.appWhiteColor
                                ),),
                              ),
                            ),
                          ):
                           const Center(
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: AppColors.appPrimaryColor,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("don_have_acc".tr,style: GoogleFonts.roboto(
                                  color: AppColors.appBlackColor
                              ),),
                              GestureDetector(
                                onTap: (){
                                  Get.to(()=> RegisterScreen());
                                },
                                child: Text("sign_up".tr,style: GoogleFonts.roboto(
                                    color: AppColors.appPrimaryColor,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationColor: AppColors.appPrimaryColor
                                ),),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16,),

                          Center(
                            child: TextButton(onPressed: (){
                              Get.to(()=> BottomNavbar(selectedIndex: 0,),transition: Transition.leftToRight);
                            }
                                , child: Text("Continue as Guest",style: GoogleFonts.roboto(
                                  fontSize: 14,fontWeight: FontWeight.w500
                                ),)),
                          ),

                          const SizedBox(height: 50,),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
