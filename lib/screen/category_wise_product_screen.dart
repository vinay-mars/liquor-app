import 'package:pringles_fine_wine/utils/product_card_image.dart';
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

  const CategoryWiseProductScreen({super.key, this.id, this.name});

  @override
  State<CategoryWiseProductScreen> createState() => _CategoryWiseProductScreenState();
}

class _CategoryWiseProductScreenState extends State<CategoryWiseProductScreen> {
  final CartController controller = Get.put(CartController());

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    _loadMoreIfNearBottom();
  }

  /// Loads the next page when scrolled near the bottom, or when the grid doesn't
  /// fill the screen yet (e.g. on iPad, where no scroll event would ever fire).
  Future<void> _loadMoreIfNearBottom() async {
    final controller = Get.find<ProductCategoryController>();
    if (!_scrollController.hasClients || !controller.isMoreDataAvailable.value) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      final loaded = await controller.getProductCategoryWiseData(widget.id, page: controller.currentPage.value + 1);
      if (!loaded) return; // already loading, or the request failed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadMoreIfNearBottom();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(_scrollListener);
      Get.find<ProductCategoryController>().resetPagination();
      await Get.find<ProductCategoryController>().getProductCategoryWiseData(widget.id,page: 1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadMoreIfNearBottom();
      });
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
                          child: const Icon(Icons.shopping_cart_outlined, size: 22, color: AppColors.appWhiteColor),
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
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  // Caps card width: 2 columns on phones, 3-4 on iPads.
                  maxCrossAxisExtent: 260,
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

                              // Image takes the space the text leaves, so the card never overflows.
                              Expanded(child: ProductCardImage(imageUrl: product["images"].isNotEmpty ? product["images"][0]["src"] : null, heroTag: item.product_id, fit: BoxFit.contain)),

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
                                  child: Icon(Icons.favorite_outline,color: AppColors.appBlackColor.withValues(alpha: 0.50),size: 24,)),
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
