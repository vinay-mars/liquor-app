import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pringles_fine_wine/controller/cart_controller.dart';
import 'package:pringles_fine_wine/controller/product_query_controller.dart';
import 'package:pringles_fine_wine/di_container.dart';
import 'package:pringles_fine_wine/utils/app_colors.dart';
import 'package:pringles_fine_wine/utils/product_card_image.dart';
import '../screen/details_screen.dart';

/// One Deals & Offer tab: a product grid for a WooCommerce query such as
/// "featured=true", fetched from the store page by page.
class ProductQueryTab extends StatefulWidget {
  final String query;
  final String emptyMessage;
  final IconData emptyIcon;

  const ProductQueryTab({
    super.key,
    required this.query,
    required this.emptyMessage,
    this.emptyIcon = Icons.local_offer_outlined,
  });

  @override
  State<ProductQueryTab> createState() => _ProductQueryTabState();
}

class _ProductQueryTabState extends State<ProductQueryTab> {
  final ScrollController _scrollController = ScrollController();
  final box = GetStorage();
  late final ProductQueryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ProductQueryController(productRepo: sl(), query: widget.query),
      tag: widget.query,
    );
    _scrollController.addListener(_loadMoreIfNearBottom);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.refreshProducts();
      _afterLayout();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Get.delete<ProductQueryController>(tag: widget.query);
    super.dispose();
  }

  void _afterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadMoreIfNearBottom();
    });
  }

  /// Loads the next page when scrolled near the bottom, or when the grid doesn't
  /// fill the screen yet (e.g. on iPad).
  Future<void> _loadMoreIfNearBottom() async {
    if (!_scrollController.hasClients || controller.isLoading || !controller.hasMore) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 300) return;
    if (await controller.loadMore()) _afterLayout();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductQueryController>(
      tag: widget.query,
      builder: (controller) {
        if (controller.products.isEmpty) {
          if (controller.isLoading || controller.hasMore && !controller.hasError) {
            return const Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(color: AppColors.appPrimaryColor),
              ),
            );
          }
          return _EmptyState(
            icon: controller.hasError ? Icons.wifi_off : widget.emptyIcon,
            message: controller.hasError
                ? "Couldn't load products. Pull down to try again."
                : widget.emptyMessage,
            onRefresh: controller.refreshProducts,
          );
        }

        return GetBuilder<CartController>(
          builder: (cartController) {
            return RefreshIndicator(
              color: AppColors.appPrimaryColor,
              onRefresh: () async {
                await controller.refreshProducts();
                _afterLayout();
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(15),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        // Caps card width: 2 columns on phones, 3-4 on iPads.
                        maxCrossAxisExtent: 260,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.66,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (_, index) => _productCard(controller.products[index], cartController),
                        childCount: controller.products.length,
                      ),
                    ),
                  ),
                  // Pagination spinner, centered below the grid.
                  if (controller.hasMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Center(
                          child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _productCard(dynamic product, CartController cartController) {
    var item = CartItem(
      product_id: product["id"].toString(),
      name: product["name"],
      image: product["images"].isNotEmpty ? product["images"][0]["src"] : null,
      price: product["price"],
    );

    // Check if the item is already in the wishlist
    bool isInWishlist = cartController.wishlistItems
        .any((existingItem) => existingItem.product_id == item.product_id);

    return GestureDetector(
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
          border: Border.all(color: AppColors.appProductBorderColor.withValues(alpha: 0.85)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image takes the space the text leaves, so the card never overflows.
                Expanded(
                  child: ProductCardImage(
                    imageUrl: product["images"].isNotEmpty ? product["images"][0]["src"] : null,
                    heroTag: item.product_id,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["categories"].isNotEmpty ? product["categories"][0]["name"].toString() : '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: const Color(0xff959396),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "${box.read("currency")}${item.price}",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.appPrimaryColor,
                              ),
                            ),
                            // Struck-through regular price for items on sale.
                            if (product["on_sale"] == true &&
                                "${product["regular_price"]}".isNotEmpty &&
                                "${product["regular_price"]}" != "${product["price"]}") ...[
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  "${box.read("currency")}${product["regular_price"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    color: const Color(0xff959396),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ],
                          ],
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
              ],
            ),
            Positioned(
              top: 8,
              right: 10,
              child: isInWishlist == false
                  ? GestureDetector(
                      onTap: () {
                        setState(() {});
                        cartController.addToWishlist(item);
                      },
                      child: Icon(
                        Icons.favorite_outline,
                        color: AppColors.appBlackColor.withValues(alpha: 0.50),
                        size: 24,
                      ),
                    )
                  : Image.asset("assets/images/wishlist_already.png", height: 24, width: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Future<void> Function() onRefresh;

  const _EmptyState({required this.icon, required this.message, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    // Scrollable so pull-to-refresh works on the empty state too.
    return RefreshIndicator(
      color: AppColors.appPrimaryColor,
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 56, color: AppColors.appPrimaryColor.withValues(alpha: 0.35)),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(fontSize: 15, color: const Color(0xff666666), height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
