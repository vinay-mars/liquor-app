import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/auth_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/cart_screen.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/photo_view_widget.dart';
import '../controller/cart_controller.dart';
import '../controller/product_controller.dart';
import 'package:badges/badges.dart' as badges;

class DetailsScreen extends StatefulWidget {
  final dynamic id;
  final dynamic name;
  final dynamic relatedIds;
  final dynamic image;
  final dynamic price;
  final dynamic variationId;
  final dynamic meta_data;

  const DetailsScreen({super.key, this.id, this.image, this.name, this.price,this.variationId,this.meta_data,this.relatedIds});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  List variationList = [];

  Map<dynamic, dynamic> variationMap = {};

  dynamic variationId;

  final box = GetStorage(); // GetStorage instance

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      variationMap={};
      variationList=[];
      selectedOptions = [];
      hasShownToast = false;
      Get.find<ProductController>().productVariationData=null;
      Get.find<ProductController>().getSingleProductData(widget.id.toString());
      Get.find<ProductController>().getAllRelatedProductsData(ids: widget.relatedIds);
      Get.find<ProductController>().getProductAllVariation(id:widget.id.toString()).then((value) {

        Get.find<ProductController>().productVariationAllData.forEach((variation) {
          dynamic id = variation["id"];
          dynamic name = variation["name"];

          variationMap[id] = name;
          print(variationMap);
          print("product variation id : $id");
          print("product variation Data : $name");
        });

      });
      Get.find<ProductController>().getAllReviewData(widget.id.toString());
    });
  }

  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;

  List<dynamic> selectedOptions = []; // To hold selected options for each attribute
  String combinedSelectedValues = ""; // To hold combined selected values

  bool hasShownToast = false;

  dynamic productPrice = 0;
  List<Map<String, String>> meta_data = []; // Initialize meta_data as a list

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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return GetBuilder<ProductController>(
          builder: (productController) {
            final CartItem item = CartItem(
              product_id: widget.id,
              name: widget.name,
              image: widget.image!=null && widget.image.isNotEmpty?widget.image:null,
              price: productPrice!=0? productPrice: widget.price,
              variation_id: variationId,
              meta_data: meta_data,
            );
            return FloatingDraggableWidget(
              dy: MediaQuery.of(context).size.height*0.5,
              dx: 0,
              floatingWidget: FloatingActionButton(
                  backgroundColor: AppColors.appPrimaryColor,
                  onPressed: (){
                      Get.to(()=> CartScreen(fromDetails: true,));
                  },
                  child: Obx(() => badges.Badge(
                    badgeContent: Text(cartController.cartItems.length.toString(),
                      style: GoogleFonts.roboto(color: Colors.white,fontSize: 15),),
                    child: Image.asset("assets/images/cart_icon.png",height: 24,width: 24,
                      color: AppColors.appWhiteColor,
                    ),
                  ))
              ),
              floatingWidgetHeight: 60,
              floatingWidgetWidth: 60,
              mainScreenWidget: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: (){
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_outlined,
                      color: AppColors.appWhiteColor,size: 18,),
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColors.appPrimaryColor,
                  title:Text("product_details".tr,style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appWhiteColor
                  ),),
                  actions:  [
                    productController.isLoadingDetails == false && productController.productDetailsData != null?
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon:const Icon(Icons.share,color: AppColors.appWhiteColor),
                            onPressed: (){
                              Share.share('${productController.productDetailsData["permalink"]}');
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 8,left: 8),
                            child: GestureDetector(
                              onTap: (){
                                cartController.addItemToCompare(item);
                              },
                              child: const Icon(Icons.cached,
                                color: AppColors.appWhiteColor,
                                size: 24,),
                            ),
                          )
                        ],
                      ),
                    ):
                    const SizedBox(),
                  ],
                ),
                body: productController.isLoadingDetails == false && productController.productDetailsData != null
                    ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [

                      productController.productDetailsData["images"].isNotEmpty
                          ? SizedBox(
                        height: 300,
                        width: 300,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productController.productDetailsData["images"].length,
                          itemBuilder: (context, index) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Get.to(()=> PhotoViewWidget(
                                      imageUrl: productController.productDetailsData["images"][index]["src"],
                                    )
                                    );
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xffE9E7EA)
                                        ),
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Image.network(productController.productDetailsData["images"][index]["src"], height: 200, width: 300,fit: BoxFit.cover,)),
                                ),
                                Positioned(
                                    bottom: 20,
                                    right: 150,
                                    left: 150,
                                    child: Container(
                                         width: 50,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff333333),
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                          child: Text(
                                            "${index+1}/${productController.productDetailsData["images"].length}",
                                            style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 16,
                                            color: AppColors.appWhiteColor
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ))),
                                Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                  onPressed: (){
                                    Get.to(()=> PhotoViewWidget(
                                      imageUrl: productController.productDetailsData["images"][index]["src"],
                                    ));
                                  },
                                  icon: const Icon(Icons.fullscreen,color: AppColors.appPrimaryColor,size: 26,),
                                ))
                              ],
                            );
                          },
                        ),
                      )
                          :  SizedBox(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset("assets/images/default_image.jpg",
                          width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text(
                        productController.productDetailsData["categories"][0]["name"],
                        style: const TextStyle(fontSize: 14,
                        color: Color(0xff959396)
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        productController.productDetailsData["name"],
                        style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 8),
                      Text("Sku : ${productController.productDetailsData["sku"]}",
                        style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
                      ),

                      if(productController.productDetailsData["stock_status"]!=null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Text("Stock : ",
                              style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            Text("${productController.productDetailsData["stock_status"]}",
                              style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500,
                              color: AppColors.appPrimaryColor,
                              ),
                            ),
                            if(productController.productDetailsData["stock_quantity"]!=null)
                            Text("(${productController.productDetailsData["stock_quantity"]})",
                              style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500,
                              color: AppColors.appPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [


                          if(productPrice!=null)...{
                            productController.productVariationData!=null && productController.isLoadingVariation==false?
                            Text("${box.read("currency")}$productPrice ",
                              style: GoogleFonts.roboto(
                                  fontSize: 24, fontWeight: FontWeight.bold
                              ),):
                            SizedBox(child: Text("${box.read("currency")}${widget.price} ",style: GoogleFonts.roboto(
                                fontSize: 24, fontWeight: FontWeight.bold
                            ),),),
                          }
                          else...{
                            Text("...",
                              style: GoogleFonts.roboto(
                                  fontSize: 24, fontWeight: FontWeight.bold
                              ),)
                          },

                          if (productController.productVariationData != null && productController.isLoadingVariation == false) ...{
                            (() {
                              final regularPriceStr = productController.productVariationData["regular_price"]?.toString() ?? '';
                              final salePriceStr = productController.productVariationData["sale_price"]?.toString() ?? '';

                              final regularPrice = double.tryParse(regularPriceStr);
                              final salePrice = double.tryParse(salePriceStr);

                              // Only show regular price with strikethrough if sale price is valid and less than regular price
                              if (regularPrice != null &&
                                  salePrice != null &&
                                  salePriceStr.isNotEmpty &&
                                  regularPrice > salePrice) {
                                return Text(
                                  "${box.read("currency")}$regularPriceStr",
                                  style: GoogleFonts.roboto(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            })(),
                          },


                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star,
                                color: AppColors
                                    .appSecondaryColor,size: 20,),
                              Text(
                                "${productController.productDetailsData["average_rating"] ?? 'N/A'} (${productController.productDetailsData["rating_count"] ?? '0'})",
                                style: GoogleFonts.roboto(
                                    fontSize: 14
                                ),
                              ),
                            ],
                          ),
                          Obx(() {
                            final quantity = cartController.cartItems
                                .firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id)
                                ?.quantity ?? 0;

                            return Container(
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: const Color(0xffE9E7EA)
                                // ),
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    quantity > 0
                                        ? Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (quantity > 0) {
                                              cartController.decreaseItemQuantity(item);
                                            }
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
                                          child: Text(
                                            quantity.toString(),
                                            style: GoogleFonts.roboto(fontSize: 14),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                           cartController.addItemToCart(item);
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
                                    )

                                        :
                                    quantity == 0
                                        ?
                                    GestureDetector(
                                      onTap: (){
                                        if(productController.productDetailsData["variations"].isEmpty){
                                          cartController.addItemToCart(item);
                                          Fluttertoast.showToast(
                                              msg: "Added in cart successfully",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: AppColors.appPrimaryColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }
                                        else{
                                          if(variationId!=null && productController.isLoadingVariation==false &&
                                          productController.productVariationData!=null){
                                            cartController.addItemToCart(item);
                                            Fluttertoast.showToast(
                                                msg: "Added in cart successfully",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: AppColors.appPrimaryColor,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          }
                                          else{
                                            Fluttertoast.showToast(
                                                msg: "Choose product variation first",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black54,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          }
                                        }

                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: AppColors.appPrimaryColor,
                                          borderRadius: BorderRadius.circular(32),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Add to Cart",
                                            style: GoogleFonts.roboto(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ),
                                      )
                                      ,
                                    )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 18),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          if(productController.productDetailsData["variations"].isNotEmpty)
                          cartController.cartItems
                              .firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id)
                              ?.meta_data!=null?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "In cart".tr,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(onPressed: (){
                                    cartController.removeSingleItemFromCart(cartController.cartItems
                                        .firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id)
                                        ?.product_id);
                                  }, child: const Text("Clear"))
                                ],
                              ),

                              Divider(
                                color: AppColors.appProductBorderColor.withOpacity(0.8),
                              ),

                              cartController.cartItems
                                  .firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id)
                                  ?.meta_data!=null?
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.appPrimaryColor.withOpacity(0.2)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                  child: Text(
                                      formatMetaData(cartController.cartItems
                                          .firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id)
                                          ?.meta_data), // Call the formatting method here
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: AppColors.appBlackColor,
                                      )),
                                ),
                              ):
                              const SizedBox(),

                              const SizedBox(height: 24,),
                            ],
                          )
                              :const SizedBox(),

                          if(productController.productDetailsData["variations"].isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "variations".tr,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                color: AppColors.appProductBorderColor.withOpacity(0.8),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: productController.productDetailsData["attributes"].length,
                                  itemBuilder: (context, index) {
                                    String attributeName = productController.productDetailsData["attributes"][index]["name"];
                                    List<String> options = List<String>.from(productController.productDetailsData["attributes"][index]["options"]);

                                    // Initialize selected option if not already done
                                    if (selectedOptions.length < productController.productDetailsData["attributes"].length) {
                                      // If only one option, select it by default
                                      if (options.length == 1) {
                                        selectedOptions.add(options[0]);

                                        // Optionally trigger the variation selection logic when auto-selected
                                        combinedSelectedValues = selectedOptions.where((element) => element != null).join(", ");

                                        if (selectedOptions.every((element) => element != null)) {
                                          bool matchFound = false;

                                          variationMap.forEach((key, value) {
                                            if (value.split(", ").every((val) => combinedSelectedValues.contains(val))) {
                                              matchFound = true;
                                              variationId = key;
                                              productPrice = null;

                                              productController.getProductVariationData(
                                                id: widget.id,
                                                variationId: key,
                                              ).then((value) {
                                                productPrice = productController.productVariationData["sale_price"];

                                                meta_data.clear();
                                                for (int i = 0; i < selectedOptions.length; i++) {
                                                  if (selectedOptions[i] != null) {
                                                    meta_data.add({
                                                      productController.productDetailsData["attributes"][i]["slug"]: selectedOptions[i],
                                                    });
                                                  }
                                                }

                                                print("Updated meta_data: $meta_data");
                                              });
                                            }
                                          });

                                          if (!matchFound && !hasShownToast) {
                                            hasShownToast = true;
                                            Get.find<ProductController>().productVariationData = null;
                                            Fluttertoast.showToast(
                                              msg: "This variation is not available",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black54,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          } else if (matchFound) {
                                            hasShownToast = false;
                                          }
                                        }

                                      } else {
                                        selectedOptions.add(null);
                                      }
                                    }

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          attributeName,
                                          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 60,
                                          width: double.infinity,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: options.length,
                                            itemBuilder: (context, subIndex) {
                                              String option = options[subIndex];
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedOptions[index] = option;
                                                      cartController.cartItems
                                                          .firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id)
                                                          ?.meta_data=null;

                                                      if(cartController.cartItems
                                                          .firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id)
                                                          ?.product_id!=null){
                                                        cartController.removeSingleItemFromCart(cartController.cartItems
                                                            .firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id)
                                                            ?.product_id);
                                                      }

                                                      // Combine selected options into a string
                                                      combinedSelectedValues = selectedOptions.where((element) => element != null).join(", ");

                                                      if (kDebugMode) {
                                                        print("User selected variant: $combinedSelectedValues");
                                                        print("Our all variation for this product: $variationMap");
                                                      }

                                                      // Check if all options are selected
                                                      if (selectedOptions.every((element) => element != null)) {
                                                        bool matchFound = false; // Track if a match is found

                                                        // Check for matches in variationMap
                                                        variationMap.forEach((key, value) {
                                                          // Check if combinedSelectedValues matches the value
                                                          if (value.split(", ").every((val) => combinedSelectedValues.contains(val))) {
                                                            print("Matched key: $key for values: $value");
                                                            matchFound = true; // Set matchFound to true if a match is found
                                                            if (key != null) {
                                                              variationId = key;
                                                              print("Current variation id is : $variationId");
                                                              productPrice = null;
                                                              productController.getProductVariationData(
                                                                id: widget.id,
                                                                variationId: key,
                                                              ).then((value) {
                                                                productPrice = productController.productVariationData["sale_price"];

                                                                // Update meta_data with all selected attributes and options
                                                                meta_data.clear(); // Clear previous data
                                                                for (int i = 0; i < selectedOptions.length; i++) {
                                                                  if (selectedOptions[i] != null) {
                                                                    meta_data.add({
                                                                      productController.productDetailsData["attributes"][i]["slug"]: selectedOptions[i],
                                                                    });
                                                                  }
                                                                }

                                                                // You can also print the updated meta_data for debugging
                                                                print("Updated meta_data: $meta_data");

                                                              });

                                                            }
                                                          }
                                                        });

                                                        // Show toast if no match found and not already shown
                                                        if (!matchFound && !hasShownToast) {
                                                          hasShownToast = true;
                                                          Get.find<ProductController>().productVariationData=null;
                                                          Fluttertoast.showToast(
                                                              msg: "This variation is not available",
                                                              toastLength: Toast.LENGTH_LONG,
                                                              gravity: ToastGravity.BOTTOM,
                                                              timeInSecForIosWeb: 1,
                                                              backgroundColor: Colors.black54,
                                                              textColor: Colors.white,
                                                              fontSize: 16.0
                                                          );
                                                        } else if (matchFound) {
                                                          hasShownToast = false; // Reset the flag if a match is found
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: AppColors.appProductBorderColor),
                                                      borderRadius: BorderRadius.circular(32),
                                                      color: selectedOptions[index] == option
                                                          ? (hasShownToast ? Colors.grey : AppColors.appPrimaryColor) // Change to red if hasShownToast is true
                                                          : Colors.white,
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                                        child: Text(
                                                          option,
                                                          style: GoogleFonts.roboto(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            color: selectedOptions[index] == option
                                                                ? AppColors.appWhiteColor
                                                                : AppColors.appBlackColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                                TextButton(onPressed: (){
                                  print("selectedOptions ${selectedOptions}");
                                  setState(() {
                                    selectedOptions = [];
                                    hasShownToast = false;
                                  });
                                  print("selectedOptions-2 ${selectedOptions}");

                                }, child: const Text("Clear")),
                              ],
                            )

                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "description".tr,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: AppColors.appProductBorderColor.withOpacity(0.8),
                      ),

                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12
                        ),
                        child: Column(
                          children: [
                            HtmlWidget(
                              '''
               ${productController.productDetailsData["description"]}                         
                        ''',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),
                      Text(
                        "rating_review".tr,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: AppColors.appProductBorderColor.withOpacity(0.8),
                      ),
                      const SizedBox(height: 8),
                      productController.isLoadingReview==false && productController.reviewData!=null?
                       Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,vertical: 16
                        ),
                        child: RatingSummary(
                          counter: productController.reviewData.length,
                          average: double.parse(productController.productDetailsData["average_rating"]),
                          showAverage: true,
                          counterFiveStars: productController.ratingCounts[5]!.toInt(),
                          counterFourStars: productController.ratingCounts[4]!.toInt(),
                          counterThreeStars: productController.ratingCounts[3]!.toInt(),
                          counterTwoStars: productController.ratingCounts[2]!.toInt(),
                          counterOneStars: productController.ratingCounts[1]!.toInt(),
                        ),
                      ):
                      const SizedBox.shrink(),

                      Get.find<AuthController>().getAuthToken().isNotEmpty?
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: (){
                            Get.bottomSheet(
                                Material(
                                  color: AppColors.appWhiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: StatefulBuilder(
                                          builder: (context,setState) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'write_review'.tr,
                                                      style: GoogleFonts.roboto(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    IconButton(onPressed: (){
                                                      Navigator.pop(context);
                                                    }, icon: const Icon(Icons.cancel))
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                                Text("your_review".tr,style: GoogleFonts.roboto(
                                                    color: AppColors.appBlackColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500
                                                ),),
                                                const SizedBox(height: 8,),
                                                TextFormField(
                                                  controller: _reviewController,
                                                  maxLines: 5,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: AppColors.appTextFieldFillColor,
                                                      hintText: "type_your_review".tr,
                                                      hintStyle: GoogleFonts.roboto(
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 14,
                                                          color: AppColors.appTextFieldHintColor
                                                      ),
                                                      border: InputBorder.none
                                                  ),
                                                  keyboardType: TextInputType.emailAddress,
                                                ),

                                                const SizedBox(height: 12),

                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('your_rating'.tr,
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.w500
                                                          ),
                                                        ),
                                                        Text(' ${_rating.toInt()}',
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.w500
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    PannableRatingBar(
                                                      rate: _rating.toDouble(),  // Ensure that the rate is a double (if it's an int, it's safe to cast it to double)
                                                      items: List.generate(5, (index) =>
                                                      const RatingWidget(
                                                        selectedColor: Colors.orange,
                                                        unSelectedColor: Colors.grey,
                                                        child: Icon(
                                                          Icons.star,
                                                          size: 35,
                                                        ),
                                                      )
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          // Convert rating to the next integer greater than or equal to the rating (ceil the value)
                                                          _rating = double.parse(value.ceil().toString());  // This ensures that if there's a decimal, it rounds up.
                                                          print("rating $_rating");
                                                        });
                                                      },
                                                    )

                                                  ],
                                                ),
                                                const SizedBox(height: 24),
                                                MaterialButton(
                                                  minWidth: double.infinity,
                                                  height: 50,
                                                  color: AppColors.appPrimaryColor,
                                                  onPressed: () async{
                                                    SharedPreferences preferences = await SharedPreferences.getInstance();

                                                    setState((){});

                                                    print("product ID : ${widget.id}");
                                                    print("product ID : ${preferences.getString("user_display_name")}");
                                                    print("product ID : ${preferences.getString("email_id")}");
                                                    print("product ID : ${_reviewController.text.toString()}");
                                                    print("product ID : ${_rating.toInt()}");

                                                    productController.createReview(
                                                        productId: widget.id,
                                                        reviewUserName: preferences.getString("user_display_name"),
                                                        reviewUserEmail: preferences.getString("email_id"),
                                                        reviewText: _reviewController.text.toString(),
                                                        rating: _rating.toInt()
                                                    ).then((value){
                                                      if(value==201){
                                                        productController.getAllReviewData(widget.id);
                                                        Navigator.pop(context);
                                                      }

                                                    });

                                                  },
                                                  child:
                                                  productController.isLoadingCreate==false?
                                                  Text('submit'.tr,style: GoogleFonts.roboto(
                                                      color: AppColors.appWhiteColor,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16
                                                  ),):
                                                  const Center(
                                                    child: SizedBox(
                                                      height: 22,
                                                      width: 22,
                                                      child: CircularProgressIndicator(
                                                        color: AppColors.appWhiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                              ],
                                            );
                                          }
                                      ),
                                    ),
                                  ),
                                )
                            );

                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color:AppColors.appProductBorderColor
                                )
                            ),
                            child: Center(
                              child: Text("write_review".tr,style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16
                              ),),
                            ),
                          ),
                        ),
                      ):
                      const SizedBox(),
                      productController.isLoadingReview==false && productController.reviewData!=null?
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: productController.reviewData.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipOval(child: Image.network("${productController.reviewData[index]["reviewer_avatar_urls"]["48"]}",
                                  height: 35,width: 35,
                                  )),
                                  const SizedBox(width: 12,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${productController.reviewData[index]["reviewer"]}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                      ),),
                                      Row(
                                        children: [
                                          PannableRatingBar(
                                            rate: productController.reviewData[index]["rating"].toDouble(),
                                            items: List.generate(5, (index) =>
                                            const RatingWidget(
                                              selectedColor: Colors.orange,
                                              unSelectedColor: Colors.grey,
                                              child: Icon(
                                                Icons.star,
                                                size: 13,
                                              ),
                                            )),
                                          ),
                                          Text(" ${productController.reviewData[index]["rating"]}.0",
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                          ),),
                                        ],
                                      ),
                                      HtmlWidget(
                                        '''
              ${productController.reviewData[index]["review"]}                       
                        ''',
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }):
                          const Center(
                            child: SizedBox(),
                          ),


                      const SizedBox(height: 16,),

                      if(productController.productRelatedData!=null)...{
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Related products",style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),),
                        ),
                        const Divider(
                          color: AppColors.appProductBorderColor,
                        ),
                        const SizedBox(height: 4,),
                        GetBuilder<CartController>(
                          builder: (cartController) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 0.62,
                              ),
                              itemCount: productController.productRelatedData.length,
                              itemBuilder: (_, index) {

                                var product = productController.productRelatedData[index];
                                var item = CartItem(
                                  product_id: product["id"].toString(),
                                  name: product["name"],
                                  image: product["images"].isNotEmpty ? product["images"][0]["src"] : null,
                                  price: product["price"],
                                );


                                // Check if the item is already in the wishlist
                                bool isInWishlist = cartController.wishlistItems
                                    .any((existingItem) => existingItem.product_id == item.product_id);


                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DetailsScreen(
                                              id: "${product["id"]}",
                                              relatedIds: product["related_ids"],
                                              name: "${product["name"]}",
                                              image: "${product["images"].isNotEmpty ? product["images"][0]["src"] : null}",
                                              price: "${product["price"]}",
                                              variationId: product["variations"].isNotEmpty? product["variations"][0]: null,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.05),
                                                spreadRadius: 0,
                                                blurRadius: 5,
                                                offset: const Offset(1,1), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: AppColors.appProductBorderColor
                                            ),
                                            color: AppColors.appWhiteColor
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  product["images"].isNotEmpty?
                                                  Center(
                                                    child: Hero(
                                                      tag: item.product_id,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 16),
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            item.image,
                                                            width: 110,
                                                            height: 110,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ):
                                                  Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 16),
                                                      child: ClipOval(
                                                        child: Image.asset("assets/images/default_image.jpg",
                                                          width: 110,
                                                          height: 110,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            product["categories"].isNotEmpty ? product["categories"][0]["name"].toString().replaceAll("&amp;", "") : '',
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.roboto(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 12,
                                                              color: const Color(0xff959396),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 6),
                                                          Text(
                                                            "${box.read("currency")}${item.price}",
                                                            style: GoogleFonts.roboto(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 2),
                                                          Text(
                                                            item.name,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.roboto(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 13,
                                                              color: const Color(0xff333333),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Row(
                                                            children: [
                                                              const Icon(Icons.star, color: AppColors.appSecondaryColor, size: 15),
                                                              Text(
                                                                "${product["average_rating"] ?? 'N/A'} (${product["rating_count"] ?? '0'})",
                                                                style: GoogleFonts.roboto(fontSize: 13),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),


                                                ],
                                              ),
                                            ),
                                            Positioned(
                                                top: 8,
                                                right: 8,
                                                child:
                                                isInWishlist==false?
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: (){
                                                          setState(() {

                                                          });
                                                          cartController.addToWishlist(item);
                                                        },
                                                        child: const Icon(Icons.favorite_outline,color: Colors.grey,size: 22,)),
                                                  ],
                                                ):const Icon(Icons.favorite,color: AppColors.appPrimaryColor,size: 22,)),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),

                      }


                    ],
                  ),
                )
                    : const Center(
                    child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: AppColors.appPrimaryColor))
                ),
              ),
            );
          },
        );
      },
    );
  }


}


