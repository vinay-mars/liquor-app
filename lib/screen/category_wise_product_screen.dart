import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/cart_controller.dart';
import '../controller/product_category_controller.dart';
import '../utils/app_colors.dart';
import 'cart_screen.dart';
import 'details_screen.dart';


class CategoryWiseProductScreen extends StatefulWidget {
  final dynamic id;
  final dynamic name;

  CategoryWiseProductScreen({super.key, this.id, this.name});

  @override
  State<CategoryWiseProductScreen> createState() => _CategoryWiseProductScreenState();
}

class _CategoryWiseProductScreenState extends State<CategoryWiseProductScreen> {
  final CartController controller = Get.put(CartController());

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more data when reaching the bottom
      Get.find<ProductCategoryController>().getProductCategoryWiseData(widget.id, page: Get.find<ProductCategoryController>().currentPage.value + 1);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
      Get.find<ProductCategoryController>().resetPagination();
      Get.find<ProductCategoryController>().getProductCategoryWiseData(widget.id,page: 1);
    });
  }

  final box = GetStorage(); // GetStorage instance

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return GetBuilder<ProductCategoryController>(
          builder: (productCategoryController) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.appPrimaryColor,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_outlined,color: AppColors.appWhiteColor,size: 20,),
                    onPressed: (){
                      Get.back();
                    },
                  ),
                  title: Text(widget.name.toString().replaceAll("&amp;", "&"),style: GoogleFonts.roboto(
                      color: AppColors.appWhiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(() => GestureDetector(
                        onTap: (){
                          Get.to(()=> CartScreen(fromDetails: true,));
                        },
                        child: badges.Badge(
                          badgeContent: Text(cartController.cartItems.length.toString(),
                            style: GoogleFonts.roboto(color: Colors.white,fontSize: 15),),
                          child: Image.asset("assets/images/cart_icon.png",height: 20,width: 20,
                              color: AppColors.appWhiteColor
                          ),
                        ),
                      )),
                    )
                  ],
                ),
              body:
              productCategoryController.isLoadingWise  && productCategoryController.productCategoryWiseData.isEmpty
                  ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: AppColors.appPrimaryColor),
                ),
              ):
              GridView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.66,
                ),
                itemCount: productCategoryController.productCategoryWiseData.length + (productCategoryController.isMoreDataAvailable.value ? 1 : 0),
                itemBuilder: (_, index) {
                  // Show loading indicator if it's the last item and more data is available
                  if (index >= productCategoryController.productCategoryWiseData.length) {
                    return const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                      ),
                    );
                  }

                  var product = productCategoryController.productCategoryWiseData[index];
                  var item = CartItem(
                    product_id: product["id"].toString(),
                    name: product["name"],
                    image: product["images"].isNotEmpty ? product["images"][0]["src"] : 'assets/images/default_image.jpg', // Default image if no image available
                    price: double.parse(product["price"].toString()),
                    variation_id: product["variations"].isNotEmpty? product["variations"][0]: null,
                  );

                  // Create a unique key for each cart icon
                  final GlobalKey cartIconKey = GlobalKey();

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
                                name: "${product["name"]}",
                                image: item.image,
                                price: "${product["price"]}",
                                variationId: product["variations"].isNotEmpty? product["variations"][0]: null,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.appProductBorderColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              product["images"].isNotEmpty?
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Hero(
                                    tag: item.product_id,
                                    child: ClipOval(
                                      child: Image.network(
                                        item.image,
                                        width: 90,
                                        height: 90,
                                        // fit: BoxFit.cover,
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

                              const SizedBox(height: 4,),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  product["categories"].isNotEmpty ? product["categories"][0]["name"].toString().replaceAll("&amp;", "") : '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: const Color(0xff959396),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "${box.read("currency")}${item.price}",
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.appPrimaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black54),
                                      ),
                                      const SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: AppColors.appSecondaryColor, size: 18,),
                                          Text(
                                            "${product["average_rating"] ?? 'N/A'} (${product["rating_count"] ?? '0'})",
                                            style: GoogleFonts.roboto(fontSize: 12),
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
                                  child: Icon(Icons.favorite_outline,color: AppColors.appBlackColor.withOpacity(0.50),size: 24,)),
                            ],
                          ):Image.asset("assets/images/wishlist_already.png",height: 28,width: 28,)),

                    ],
                  );
                },
              )

            );
          },
        );
      }
    );
  }

}
