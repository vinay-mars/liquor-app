import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'my_order_screen.dart';


class OrderSuccessScreen extends StatelessWidget {
  final bool isGuest; // add this
  const OrderSuccessScreen({super.key, this.isGuest = false});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appPrimaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/order_processed.png",
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20.0),
               Text(
                'order_placed'.tr,
                style: GoogleFonts.roboto(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text("go_to_order".tr,style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white54
              ),),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  Get.offAll(()=> MyOrderScreen(
                    orderPage: true,
                      isGuest: isGuest
                  ));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                ),
                child: Text('view_order'.tr,style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
