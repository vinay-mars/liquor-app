import 'package:get/get.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/product_repo.dart';

/// Paginated product list for one WooCommerce query (Featured / On Sale /
/// Best Sellers tabs). Registered per query with `Get.put(..., tag: query)` so
/// each tab keeps its own list, separate from the home screen's
/// ProductController.
class ProductQueryController extends GetxController {
  final ProductRepo productRepo;
  final String query;

  ProductQueryController({required this.productRepo, required this.query});

  static const int _perPage = 20;

  List<dynamic> products = [];
  int _page = 0;
  bool isLoading = false;
  bool hasMore = true;
  bool hasError = false;

  /// Loads the first page again, replacing the current list.
  Future<void> refreshProducts() async {
    _page = 0;
    hasMore = true;
    products = [];
    await loadMore();
  }

  /// Loads the next page. Returns true when a page was fetched.
  Future<bool> loadMore() async {
    if (isLoading || !hasMore) return false;
    isLoading = true;
    hasError = false;
    update();

    final ApiResponse apiResponse =
        await productRepo.getProductsByQuery(query, page: _page + 1);
    isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200 &&
        apiResponse.response!.data is List) {
      final List<dynamic> newData = apiResponse.response!.data;
      products.addAll(newData);
      _page++;
      // A short page means this was the last one.
      hasMore = newData.length >= _perPage;
      update();
      return true;
    }

    hasError = true;
    update();
    return false;
  }
}
