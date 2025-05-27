import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/cart_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/product_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';

import '../screen/details_screen.dart';

class OnSaleTab extends StatefulWidget {
  const OnSaleTab({super.key});

  @override
  State<OnSaleTab> createState() => _OnSaleTabState();
}

class _OnSaleTabState extends State<OnSaleTab> {

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more data when reached the bottom
      Get.find<ProductController>().getProductData(page: Get.find<ProductController>().currentPage + 1);
    }
  }

  final box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProduct();
      _scrollController.addListener(_scrollListener);
    });
    super.initState();
  }

  _loadProduct() async {
    await Get.find<ProductController>().getProductData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        builder: (productController) {
          return GetBuilder<CartController>(
            builder: (cartController) {
              return GridView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.66,
                ),
                // Filter products to show only featured items
                itemCount: productController.productData.where((product) => product["on_sale"] == true).length + (productController.isMoreDataAvailable ? 1 : 0),
                itemBuilder: (_, index) {
                  // Get the featured products
                  var featuredProducts = productController.productData.where((product) => product["on_sale"] == true).toList();

                  if (index >= featuredProducts.length) {
                    return const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                      ),
                    );
                  }

                  var product = featuredProducts[index];
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
                                name: "${product["name"]}",
                                image: "${product["images"].isNotEmpty ? product["images"][0]["src"] : null}",
                                price: "${product["price"]}",
                                variationId: product["variations"].isNotEmpty ? product["variations"][0] : null,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.appProductBorderColor.withOpacity(0.85)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  product["images"].isNotEmpty
                                      ? Center(
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
                                  )
                                      : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/images/default_image.jpg",
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
                                              color: AppColors.appPrimaryColor,
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
                              Positioned(
                                top: 8,
                                right: 10,
                                child: isInWishlist == false
                                    ? Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {});
                                        cartController.addToWishlist(item);
                                      },
                                      child: Icon(
                                        Icons.favorite_outline,
                                        color: AppColors.appBlackColor.withOpacity(0.50),
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                )
                                    : Image.asset(
                                  "assets/images/wishlist_already.png",
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        }
    );
  }
}