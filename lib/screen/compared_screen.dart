import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/cart_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/compare_result_screen.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';
import 'details_screen.dart';

class ComparedScreen extends StatefulWidget {
  const ComparedScreen({super.key});

  @override
  State<ComparedScreen> createState() => _ComparedScreenState();
}

class _ComparedScreenState extends State<ComparedScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Get.find<CartController>().loadCompareList();
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
               leading: IconButton(
                 onPressed: (){
                   Get.back();
                 },
                 icon: const Icon(Icons.arrow_back,color: AppColors.appWhiteColor,),
               ),
               title:Text("compared_items".tr,style: GoogleFonts.roboto(
                   fontSize: 16,
                   fontWeight: FontWeight.w500,
                   color: AppColors.appWhiteColor
               ),),
               actions: [
                 TextButton(onPressed: (){
                   cartController.removeAllItemsFromCompare();
                 }, child: Text("clear_all".tr,style: GoogleFonts.roboto(
                     fontSize: 12,
                     color: AppColors.appWhiteColor,
                     decoration: TextDecoration.underline,decorationColor: AppColors.appWhiteColor
                 ),))
               ],
             ),
             body:
             cartController.compareItems.isNotEmpty?
             SingleChildScrollView(
               child: Column(
                 children: [
                   const SizedBox(height: 16,),
                   ListView.builder(
                       physics: const NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       itemCount: cartController.compareItems.length,
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
                                     id: "${cartController.compareItems[index].product_id}",
                                     name: "${cartController.compareItems[index].name}",
                                     image: "${cartController.compareItems[index].image}",
                                     price: "${cartController.compareItems[index].price}",
                                     variationId: "${cartController.compareItems[index].variation_id}",
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
                                         cartController.compareItems[index].image.isNotEmpty?
                                         Image.network(
                                           "${cartController.compareItems[index].image}",
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
                                           "${cartController.compareItems[index].name}",
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
                                               '${box.read("currency")}${double.parse(cartController.compareItems[index].price.toString()).toStringAsFixed(2)}',
                                               style: GoogleFonts.roboto(
                                                 fontSize: 18,
                                                 fontWeight: FontWeight.w500,
                                                 color: AppColors.appBlackColor,
                                               ),
                                             ),
                                             IconButton(onPressed: (){
                                               cartController.removeItemFromCompare(cartController.compareItems[index].product_id);
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
                   Text("no_compared_item".tr,style: GoogleFonts.outfit(),),
                 ],
               ),
             ),
             bottomNavigationBar: BottomAppBar(
               elevation: 0,
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(4),
                 child: MaterialButton(
                   color: AppColors.appPrimaryColor,
                   onPressed: (){
                     if(Get.find<CartController>().compareItems.length<2){
                       Get.snackbar(
                         'Check!',
                         'At least 2 item required for comparison',
                         snackPosition: SnackPosition.BOTTOM,
                         backgroundColor: Colors.white,
                       );
                     }
                     else{
                       Get.to(()=> const CompareResultScreen());
                     }

                   },
                   child: Center(
                     child: Text("show_me_comparison".tr,style: GoogleFonts.outfit(
                       fontWeight: FontWeight.w500,
                       fontSize: 16,
                       color: AppColors.appWhiteColor
                     ),),
                   ),
                 ),
               ),
             ),
           );
         }
     );
  }
}
