import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/cart_controller.dart';
import '../utils/app_colors.dart';
import 'details_screen.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Get.find<CartController>().loadWishlist();
    super.initState();
  }

  final box = GetStorage(); // GetStorage instance

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return Scaffold(
          backgroundColor: AppColors.appWhiteColor,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.appPrimaryColor,
            title:Text("wishlist".tr,style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.appWhiteColor
            ),),
            actions: [
              TextButton(onPressed: (){
                cartController.clearWishlist();
              }, child: Text("clear_all".tr,style: GoogleFonts.roboto(
                fontSize: 12,
                color: AppColors.appWhiteColor,
                decoration: TextDecoration.underline,decorationColor: AppColors.appWhiteColor
              ),))
            ],
          ),
          body:
          cartController.wishlistItems.isNotEmpty?
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16,),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cartController.wishlistItems.length,
                        itemBuilder: (context,index){
                         return Padding(
                           padding: const EdgeInsets.symmetric(
                             horizontal: 16
                           ),
                           child: GestureDetector(
                             onTap: (){
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (_) => DetailsScreen(
                                     id: "${cartController.wishlistItems[index].product_id}",
                                     name: "${cartController.wishlistItems[index].name}",
                                     image: "${cartController.wishlistItems[index].image}",
                                     price: "${cartController.wishlistItems[index].price}",
                                     variationId: "${cartController.wishlistItems[index].variation_id}",
                                   ),
                                 ),
                               );
                             },
                             child: Container(
                               margin: const EdgeInsets.only(bottom: 15), // Space between items
                               padding: const EdgeInsets.all(10),
                               decoration: BoxDecoration(
                                 color: const Color(0xffF7F7F7),
                                 borderRadius: BorderRadius.circular(12),
                               ),
                               child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                   // Item image
                                   Container(
                                     alignment: Alignment.center,
                                     decoration: BoxDecoration(
                                       color: AppColors.appWhiteColor,
                                       borderRadius: BorderRadius.circular(8),
                                     ),
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child:
                                       cartController.wishlistItems[index].image.isNotEmpty?
                                       Image.network(
                                         "${cartController.wishlistItems[index].image}",
                                         width: 60,
                                       ):
                                       Image.asset(
                                         "assets/images/default_image.jpg",
                                         width: 60,
                                       )
                                     ),
                                   ),
                                   const SizedBox(width: 10),
                                   // Item details
                                   Expanded(
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(
                                           "${cartController.wishlistItems[index].name}",
                                           style: GoogleFonts.roboto(
                                             fontSize: 14,
                                             fontWeight: FontWeight.w500,
                                           ),
                                           maxLines: 2,
                                           overflow: TextOverflow.ellipsis,
                                         ),
                                         const SizedBox(height: 4),
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Text(
                                               '${box.read("currency")}${double.parse(cartController.wishlistItems[index].price.toString()).toStringAsFixed(2)}',
                                               style: GoogleFonts.roboto(
                                                 fontSize: 18,
                                                 fontWeight: FontWeight.w500,
                                                 color: AppColors.appBlackColor,
                                               ),
                                             ),
                                             IconButton(onPressed: (){
                                               cartController.removeFromWishlist(cartController.wishlistItems[index].product_id);
                                             }, icon: const Icon(Icons.delete_outline,))
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         );
                    }),
                  ],
                ),
              ):
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/images/search_lottie.json',
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                Text("no_wishlist".tr,style: GoogleFonts.outfit(),),
              ],
            ),
          ),
        );
      }
    );
  }
}
