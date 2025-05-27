import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller.dart';
import '../utils/app_colors.dart';


class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool obSecureText = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return
          Scaffold(
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
                            opacity: 0.4,
                            child: Image.asset("assets/images/splash_bg.png",fit: BoxFit.cover,width: double.infinity,)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xff167A52).withOpacity(0.3),
                                      const Color(0xff167A52),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Image.asset("assets/images/splash_logo.png",height: 60,width: 180,)),
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

                        Text("create_acc".tr,style: GoogleFonts.roboto(
                            color: AppColors.appBlackColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),),

                        Text("fill_info".tr,style: GoogleFonts.roboto(
                            color: AppColors.appWelcomeBackTxtColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),),

                        const SizedBox(height: 35,),

                        Text("names".tr,style: GoogleFonts.roboto(
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
                              hintText: "type_name".tr,
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

                        Text("email".tr,style: GoogleFonts.roboto(
                            color: AppColors.appBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),),

                        const SizedBox(height: 8,),

                        // Username TextField
                        TextField(
                          controller: _emailController,
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
                                child: const Icon(Icons.remove_red_eye_rounded,color: AppColors.appWelcomeBackTxtColor,)),
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

                        const SizedBox(height: 45),
                        // Login Button
                        authController.isLoadingRegister==false?
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: MaterialButton(
                              color: AppColors.appPrimaryColor,
                              onPressed: () {
                                authController.register(
                                    context,
                                    _usernameController.text.toString(),
                                    _emailController.text.toString(),
                                    _passwordController.text.toString()
                                );
                              },
                              height: 45,
                              minWidth: double.infinity,
                              child: Text('sign_up'.tr,style: GoogleFonts.roboto(
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
                            Text("already_acc".tr,style: GoogleFonts.roboto(
                                color: AppColors.appBlackColor
                            ),),
                            GestureDetector(
                              onTap: (){
                                Get.back();
                              },
                              child: Text("sign_in".tr,
                                style: GoogleFonts.roboto(
                                  color: AppColors.appPrimaryColor,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: AppColors.appPrimaryColor
                              ),),
                            ),
                          ],
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