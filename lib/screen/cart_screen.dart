import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/details_screen.dart';
import '../controller/auth_controller.dart';
import '../controller/cart_controller.dart';
import '../utils/app_colors.dart';
import 'checkout_screen.dart';
import 'login_screen.dart';

class CartScreen extends StatelessWidget {
  bool? fromDetails;
  CartScreen({Key? key,this.fromDetails}) : super(key: key);

  // Method to format the meta_data
  String formatMetaData(List<Map<String, String>> metaData) {
    List<String> formattedList = metaData.map((entry) {
      // Extract the key and value
      String key = entry.keys.first; // Get the first key
      String value = entry[key]!; // Get the corresponding value

      // Remove the "pa_" prefix from the key
      String formattedKey = key.replaceFirst('pa_', '');

      // Return the formatted string
      return '$formattedKey: $value';
    }).toList();

    // Join the formatted strings with commas
    return formattedList.join(', ');
  }

  final box = GetStorage(); // GetStorage instance

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return Scaffold(
          backgroundColor: AppColors.appWhiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.appPrimaryColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading:
            fromDetails==true?
            IconButton(
              onPressed: (){
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined,
                color: AppColors.appWhiteColor,size: 18,),
            ):null,
            title: Text('cart'.tr,style: GoogleFonts.roboto(
                color: AppColors.appWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: (){
                  cartController.removeAllItemsFromCart();
                },
                child: Text("clear_all".tr,style: GoogleFonts.roboto(
                  fontSize: 12,
                  height: 1.8,
                  color: AppColors.appWhiteColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.appWhiteColor
                ),),
              ),
            )
          ],
          ),
          body: Obx(() {
            if (cartController.cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/empty_cart.png",height: 180,width: 180,),
                    Text(
                      'your_cart_empty'.tr,
                      style: GoogleFonts.roboto(fontSize: 24,
                          color: AppColors.appBlackColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      "looks_no_choice".tr,
                      style: GoogleFonts.roboto(fontSize: 14,
                          color: const Color(0xff959396),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartController.cartItems[index];

                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsScreen(
                                id: cartItem.product_id,
                                name: cartItem.name,
                                image: cartItem.image!=null && cartItem.image.isNotEmpty?cartItem.image:null,
                                price: cartItem.price,
                                variationId: cartItem.variation_id,
                                meta_data: cartItem.meta_data,
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
                                  cartItem.image.toString()!="null" ?
                                  Image.network(
                                    "${cartItem.image}",
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
                                      cartItem.name,
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${box.read("currency")}${double.parse(cartItem.price.toString()).toStringAsFixed(2)}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.appBlackColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                Text(
                                  formatMetaData(cartItem.meta_data), // Call the formatting method here
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: AppColors.appBlackColor,
                                  )),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Quantity and removal options
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      cartController.removeSingleItemFromCart(cartItem.product_id);
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffD7D7D7),
                                        borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: const Center(child: Icon(Icons.delete_outline,size: 15,)),
                                    ),
                                  ),

                                  const SizedBox(height: 24,),

                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.appWhiteColor,
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              cartController.decreaseItemQuantity(cartItem);
                                            },
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                  color: const Color(0xffD7D7D7),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: const Center(
                                                child: Icon(Icons.remove,size: 16,),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            child: Obx(() {
                                              int quantity = cartController.cartItems.firstWhereOrNull((item) => item.product_id == cartItem.product_id)?.quantity ?? 0;
                                                  return Text(quantity.toString());
                                                }),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              cartController.addItemToCart(cartItem);
                                            },
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                  color: const Color(0xffD7D7D7),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: const Center(
                                                child: Icon(Icons.add,size: 16,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )

                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total_items'.tr,
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Obx(() {
                            return Text(
                              cartController.itemCount.value.toString(),
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            'total_price'.tr,
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Obx(() {
                            return Text(
                              '${box.read("currency")}${cartController.totalPrice.value.toStringAsFixed(2)}',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        height: 48,
                        minWidth: double.infinity,
                        color: AppColors.appPrimaryColor,
                        onPressed: () {
                          if (Get.find<AuthController>().getAuthToken().isEmpty) {
                            // User not logged in -> directly go to checkout screen without prefilled address
                            Get.to(() => const CheckoutScreen(isGuest: true));
                          } else {
                            // User logged in -> go to checkout screen with profile address loaded
                            Get.to(() => const CheckoutScreen(isGuest: false));
                          }
                        },
                        child: Text('checkout'.tr, style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: AppColors.appWhiteColor
                        )),
                      ),

                    ],
                  ),
                ),
              ],
            );
          }),
        );
      }
    );
  }
}
