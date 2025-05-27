import 'package:get/get.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/product_category_repo.dart';

class ProductCategoryController extends GetxController {
  final ProductCategoryRepo productCategoryRepo;

  ProductCategoryController({required this.productCategoryRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingWise = false;
  bool get isLoadingWise => _isLoadingWise;

  dynamic productCategoryWiseData = [];
  var isMoreDataAvailable = true.obs; // Track if more data is available
  var currentPage = 1.obs; // Current page

  dynamic productCategoryData;

  /// Get all product Category Data
  Future<dynamic> getProductCategoryData() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await productCategoryRepo.getProductCategory();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        productCategoryData = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  /// Reset pagination
  void resetPagination() {
    currentPage.value = 1; // Reset to the first page
    productCategoryWiseData.clear(); // Clear the existing data
    isMoreDataAvailable.value = true; // Reset availability of more data
  }

  /// Get all product Category wise Data with pagination
  Future<dynamic> getProductCategoryWiseData(dynamic id, {int page = 1}) async {
    // Prevent multiple calls or if no more data is available
    if (_isLoadingWise || !isMoreDataAvailable.value) return;

    // Set loading state only for initial load
    if (page == 1) {
      _isLoadingWise = true;
      update();
    }

    ApiResponse apiResponse = await productCategoryRepo.getProductCategoryWiseData(id, page);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      // Only set loading state to false if this is the first page
      if (page == 1) {
        _isLoadingWise = false;
      }

      if (apiResponse.response!.data != null) {
        List<dynamic> newData = apiResponse.response!.data!;

        if (newData.isEmpty) {
          isMoreDataAvailable.value = false; // No more data to load
        } else {
          if (page == 1) {
            productCategoryWiseData = newData; // Reset for the first page
          } else {
            productCategoryWiseData.addAll(newData); // Append new data
          }
          currentPage.value = page; // Update the current page
        }
        update();
      }
    } else {
      // Handle errors
      _isLoadingWise = false;
      update();
    }
  }
}
