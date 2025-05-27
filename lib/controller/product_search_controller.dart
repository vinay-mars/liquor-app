import 'package:get/get.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/product_search_repo.dart';

class ProductSearchController extends GetxController {
  final ProductSearchRepo productSearchRepo;

  ProductSearchController({required this.productSearchRepo});

  var isLoading = false.obs;
  var isMoreDataAvailable = true.obs;
  var currentPage = 1.obs;
  var productSearchData = <dynamic>[].obs;

  /// Get product data with pagination
  Future<void> getProductSearchData({
    dynamic search,
    dynamic category,
    dynamic minPrice,
    dynamic maxPrice,
    int page = 1,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    ApiResponse apiResponse = await productSearchRepo.getProductSearchData(
      search: search,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      page: page,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      List<dynamic> newData = apiResponse.response!.data;

      isLoading.value==false;
      update();

      if (newData.isEmpty) {
        isMoreDataAvailable.value = false; // No more data to load
      } else {
        if (page == 1) {
          productSearchData.value = newData; // Replace data on refresh
        } else {
          productSearchData.addAll(newData); // Append data
          isLoading.value==false;
          update();
        }
        currentPage.value = page;
        update();
      }
    } else {
      // Handle error (optional)
      isLoading.value==false;
      update();
    }
    isLoading.value = false;
    update();
  }
}
