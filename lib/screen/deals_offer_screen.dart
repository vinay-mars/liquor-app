import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/product_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/featured_products.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/on_sale.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/top_rated.dart';

class DealsOfferScreen extends StatefulWidget {
   const DealsOfferScreen({super.key});

  @override
  State<DealsOfferScreen> createState() => _DealsOfferScreenState();
}

class _DealsOfferScreenState extends State<DealsOfferScreen> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return DefaultTabController(
          length: 3, // Number of tabs
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: (){
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back,color: AppColors.appWhiteColor,),
              ),
              backgroundColor: AppColors.appPrimaryColor,
              title: Text("deals_offer".tr,style: GoogleFonts.roboto(
                color: AppColors.appWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),),
              centerTitle: true,
              bottom: TabBar(
                physics: const NeverScrollableScrollPhysics(),
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelStyle: GoogleFonts.openSans(
                  color: AppColors.appWhiteColor,
                  fontWeight: FontWeight.w500
                ),
                labelColor: AppColors.appSecondaryColor,
                indicatorColor: AppColors.appSecondaryColor,
                labelStyle: GoogleFonts.openSans(
                  fontWeight: FontWeight.w600
                ),
                tabs: const [
                  Tab(text: "Featured"),
                  Tab(text: "On Sale"),
                  Tab(text: "Top Rated"),
                ],
              ),
            ),
            body:
            const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                FeaturedTab(),
                OnSaleTab(),
                TopRatedTab(),
              ],
            )
          ),
        );
      }
    );
  }
}

