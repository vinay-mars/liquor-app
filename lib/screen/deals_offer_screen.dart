import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pringles_fine_wine/utils/app_colors.dart';
import 'package:pringles_fine_wine/utils/product_query_tab.dart';

class DealsOfferScreen extends StatefulWidget {
  /// 0 = Featured, 1 = On Sale, 2 = Best Sellers.
  final int initialTab;

  const DealsOfferScreen({super.key, this.initialTab = 0});

  @override
  State<DealsOfferScreen> createState() => _DealsOfferScreenState();
}

class _DealsOfferScreenState extends State<DealsOfferScreen> {

  @override
  Widget build(BuildContext context) {
        return DefaultTabController(
          length: 3, // Number of tabs
          initialIndex: widget.initialTab,
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
                  Tab(text: "Best Sellers"),
                ],
              ),
            ),
            body:
            // Each tab asks WooCommerce for its own products.
            const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ProductQueryTab(
                  query: "featured=true",
                  emptyMessage: "No featured products right now.\nCheck back soon!",
                  emptyIcon: Icons.star_outline,
                ),
                ProductQueryTab(
                  query: "on_sale=true",
                  emptyMessage: "No sale items right now.\nCheck back soon for new deals!",
                  emptyIcon: Icons.local_offer_outlined,
                ),
                ProductQueryTab(
                  query: "orderby=popularity&order=desc",
                  emptyMessage: "No best sellers to show yet.",
                  emptyIcon: Icons.trending_up,
                ),
              ],
            )
          ),
        );
  }
}

