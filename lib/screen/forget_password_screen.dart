import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/lost_password_response.dart';
import '../controller/auth_controller.dart';
import '../utils/app_colors.dart';

class ForgetPasswordScreen extends StatelessWidget {
   ForgetPasswordScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        builder: (authController) {
          return Scaffold(
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
                          color: AppColors.appPrimaryColor,
                        ),
                        Opacity(
                            opacity: 0.2,
                            child: Image.asset("assets/images/splash_bg.png",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.appPrimaryColor.withOpacity(0.2),
                                      AppColors.appPrimaryColor,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Image.asset("assets/images/app_logo.png",height: 120,width: 170,)),
                          ),
                        ),


                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16,right: 16,top: 24
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Text("forget_password".tr,style: GoogleFonts.roboto(
                            color: AppColors.appBlackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),),
                        const SizedBox(height: 4,),

                        Text("forget_txt".tr,style: GoogleFonts.roboto(
                            color: AppColors.appWelcomeBackTxtColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),),

                        const SizedBox(height: 36,),

                        Text("username".tr,style: GoogleFonts.roboto(
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
                              hintText: "type_username".tr,
                              hintStyle: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: AppColors.appTextFieldHintColor
                              ),
                              border: InputBorder.none
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),


                        const SizedBox(height: 45),
                        // Login Button
                        authController.isLoadingForget==false?
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: MaterialButton(
                              color: AppColors.appPrimaryColor,
                              onPressed: () async{
                                authController.forgetPassword(context, _usernameController.text.toString()).then((value) {
                                  if(value==200){
                                   Get.to(()=> LostPasswordResponse(response: authController.response,));
                                  }
                                });


                              },
                              height: 45,
                              minWidth: double.infinity,
                              child: Text('reset_password'.tr,style: GoogleFonts.roboto(
                                  fontSize: 15,
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

                        const SizedBox(height: 50,),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }
}
