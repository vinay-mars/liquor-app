import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
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
    );

    // Scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Reached bottom of the list, load more data
        if (productSearchController.isMoreDataAvailable.value && !productSearchController.isLoading.value) {
          productSearchController.getProductSearchData(
            search: widget.search,
            category: widget.category,
            minPrice: widget.minPrice,
            maxPrice: widget.maxPrice,
            page: productSearchController.currentPage.value + 1,
          );
        }
      }
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
                  // actions: [
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 20),
                  //     child: Obx(() => GestureDetector(
                  //       onTap: (){
                  //         Get.to(()=> CartScreen(fromDetails: true,));
                  //       },
                  //       child: badges.Badge(
                  //         badgeContent: Text(cartController.cartItems.length.toString(),
                  //           style: GoogleFonts.roboto(color: Colors.white,fontSize: 15),),
                  //         child: Image.asset("assets/images/cart_icon.png",height: 20,width: 20,
                  //           color: AppColors.appWhiteColor
                  //         ),
                  //       ),
                  //     )),
                  //   )
                  // ],
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

                                  product["images"].isNotEmpty?
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Hero(
                                        tag: item.product_id,
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
                    }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
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

  void _flyToCart(BuildContext context, CartItem item, GlobalKey cartIconKey) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Positioned(
                  right: 15,
                  top: 30,
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: Hero(
                      tag: item.product_id,
                      child: Image.network(
                        item.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),

                      flightShuttleBuilder: (flightContext, animation, direction,
                          fromContext, toContext) {
                        if(direction == HeroFlightDirection.push) {
                          return Image.network(
                            item.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          );
                        } else if (direction == HeroFlightDirection.pop){
                          return const SizedBox();
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Only apply the fade transition on push
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      // This pop action will not animate the Hero
      Navigator.of(context).pop();
    });
  }

}

