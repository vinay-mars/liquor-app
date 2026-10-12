import 'package:pringles_fine_wine/utils/product_card_image.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pringles_fine_wine/screen/cart_screen.dart';
import '../controller/cart_controller.dart';
import '../controller/product_search_controller.dart';
import '../utils/app_colors.dart';
import 'details_screen.dart';

class HomeFilterScreen extends StatefulWidget {
  final dynamic search;
  final dynamic category;
  final dynamic minPrice;
  final dynamic maxPrice;

  const HomeFilterScreen({super.key, this.search, this.maxPrice, this.minPrice, this.category});

  @override
  State<HomeFilterScreen> createState() => _HomeFilterScreenState();
}

class _HomeFilterScreenState extends State<HomeFilterScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final productSearchController = Get.find<ProductSearchController>();
    productSearchController.productSearchData.clear();
    productSearchController.isMoreDataAvailable.value = true;
    productSearchController.currentPage.value = 1;
    // Initial data load
    productSearchController.getProductSearchData(
      search: widget.search,
      category: widget.category,
      minPrice: widget.minPrice,
      maxPrice: widget.maxPrice,
      page: productSearchController.currentPage.value,
    ).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadMoreIfNearBottom();
      });
    });

    // Scroll listener for pagination
    _scrollController.addListener(_loadMoreIfNearBottom);
  }

  /// Loads the next page when scrolled near the bottom, or when the results
  /// don't fill the screen yet (e.g. on iPad, where no scroll event would fire).
  Future<void> _loadMoreIfNearBottom() async {
    final productSearchController = Get.find<ProductSearchController>();
    if (!_scrollController.hasClients ||
        !productSearchController.isMoreDataAvailable.value ||
        productSearchController.isLoading.value) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 300) return;
    await productSearchController.getProductSearchData(
      search: widget.search,
      category: widget.category,
      minPrice: widget.minPrice,
      maxPrice: widget.maxPrice,
      page: productSearchController.currentPage.value + 1,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadMoreIfNearBottom();
    });
  }

  TextEditingController searchController = TextEditingController();

  final box = GetStorage(); // GetStorage instance

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
        builder: (cartController) {
          return GetBuilder<ProductSearchController>(
            builder: (productSearchController) {
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
                  title: Text('Search Results',style: GoogleFonts.roboto(
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

                productSearchController.isLoading.value  && productSearchController.productSearchData.isEmpty
                    ? const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: AppColors.appPrimaryColor),
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: () async {
                    productSearchController.productSearchData.clear();
                    productSearchController.isMoreDataAvailable.value = true;
                    productSearchController.currentPage.value = 1;
                    await productSearchController.getProductSearchData(
                      search: widget.search,
                      category: widget.category,
                      minPrice: widget.minPrice,
                      maxPrice: widget.maxPrice,
                      page: 1,
                    );
                  },
                  child: GridView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    padding: const EdgeInsets.all(15),
                    itemCount: productSearchController.productSearchData.length + (productSearchController.isMoreDataAvailable.value ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index >= productSearchController.productSearchData.length ) {
                        // Show a loading indicator while fetching more data
                        return const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                          ),
                        );
                      }

                      var product = productSearchController.productSearchData[index];
                      var item = CartItem(
                        product_id: product["id"].toString(),
                        name: product["name"],
                        image: product["images"].isNotEmpty?product["images"][0]["src"]: null,
                        price: double.parse(product["price"].toString()),
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
                                    image: "${product["images"].isNotEmpty ? product["images"][0]["src"] : ''}",
                                    price: "${product["price"]}",
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

                                  Expanded(child: ProductCardImage(imageUrl: product["images"].isNotEmpty ? product["images"][0]["src"] : null, heroTag: item.product_id, fit: BoxFit.contain)),
Padding(
                                      padding:
                                      const EdgeInsets.only(top: 12,left: 12,right: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            product["categories"].isNotEmpty ? product["categories"][0]["name"].toString().replaceAll("&amp;", "") : '',
                                            maxLines: 2,
                                            overflow: TextOverflow
                                                .ellipsis,
                                            style: GoogleFonts.roboto(
                                              fontWeight:
                                              FontWeight.w400,
                                              fontSize: 12,
                                              color: const Color(0xff959396),
                                            ),
                                          ),
                                          const SizedBox(height: 4,),
                                          Text(
                                            "${box.read("currency")}${item.price}",
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: AppColors.appPrimaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4,),
                                          Text(
                                            item.name,
                                            maxLines: 2,
                                            overflow: TextOverflow
                                                .ellipsis,
                                            style: GoogleFonts.roboto(
                                              fontWeight:
                                              FontWeight.w500,
                                              fontSize: 12,
                                              color: const Color(0xff333333),
                                            ),
                                          ),
                                          const SizedBox(height: 8,),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                color: AppColors
                                                    .appSecondaryColor,size: 15,),
                                              Text(
                                                "${product["average_rating"] ?? 'N/A'} (${product["rating_count"] ?? '0'})",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 13
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                    }, gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    // Caps card width: 2 columns on phones, 3-4 on iPads.
                    maxCrossAxisExtent: 260,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.66,
                  ),
                  ),
                ),
              );
            },
          );
        }
    );
  }

}

