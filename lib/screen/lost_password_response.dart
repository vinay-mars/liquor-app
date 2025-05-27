import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';

class LostPasswordResponse extends StatelessWidget {
  dynamic response;
  LostPasswordResponse({super.key,this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(Icons.arrow_back,color: AppColors.appWhiteColor,),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appPrimaryColor,
        title: Text("Reset Password",style: GoogleFonts.roboto(
          color: AppColors.appWhiteColor,
              fontWeight: FontWeight.w500,fontSize: 16
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,vertical: 12
        ),
        child: HtmlWidget(
          '''
                                          ${response}
                                              ''',
        ),
      ),
    );
  }
}
