import 'package:get/get.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/product_repo.dart';

class ProductController extends GetxController {
  final ProductRepo productRepo;

  ProductController({required this.productRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingCreate = false;
  bool get isLoadingCreate => _isLoadingCreate;

  bool _isLoadingDetails = false;
  bool get isLoadingDetails => _isLoadingDetails;

  bool _isLoadingComparison1 = false;
  bool get isLoadingComparison1 => _isLoadingComparison1;

  bool _isLoadingComparison2 = false;
  bool get isLoadingComparison2 => _isLoadingComparison2;

  bool _isLoadingVariation = false;
  bool get isLoadingVariation => _isLoadingVariation;

  bool _isLoadingVariationAll = false;
  bool get isLoadingVariationAll => _isLoadingVariationAll;

  bool _isLoadingReview = false;
  bool get isLoadingReview => _isLoadingReview;

  bool _isLoadingRelated = false;
  bool get isLoadingRelated => _isLoadingRelated;

  dynamic productData = []; // Use an observable list for products
  dynamic productDetailsData;
  dynamic productComparisonData1;
  dynamic productComparisonData2;
  dynamic productVariationData;
  dynamic productVariationAllData;
  dynamic reviewData;
  dynamic productRelatedData;

  Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  int currentPage = 1; // Track the current page
  bool isMoreDataAvailable = true; // Track if more data is available

  /// Get all product data with pagination
  Future<void> getProductData({int page = 1}) async {
    if (!_isLoading && isMoreDataAvailable) {
      _isLoading = true;
      update();

      ApiResponse apiResponse = await productRepo.getProductData(page: page);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _isLoading = false;
        update();

        if (apiResponse.response!.data != null) {
          if (page == 1) {
            productData = apiResponse.response!.data!; // Replace data on refresh
          } else {
            productData.addAll(apiResponse.response!.data!); // Append new data
          }
          currentPage = page;
          isMoreDataAvailable = apiResponse.response!.data!.length > 0; // Check if more data is available
          update();
        }
      } else {
        _isLoading = false;
        update();
      }
    }
  }

  /// getAllRelated products data
  Future<void> getAllRelatedProductsData({dynamic ids}) async {
    _isLoadingRelated = true;
    update();
    ApiResponse apiResponse = await productRepo.getAllRelatedProducts(ids: ids);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingRelated = false;
      update();

      if (apiResponse.response!.data != null) {
        productRelatedData = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoadingRelated = false;
      update();
    }
  }

  /// Get single product data
  Future<void> getSingleProductData(dynamic id) async {
    _isLoadingDetails = true;
    update();
    ApiResponse apiResponse = await productRepo.getProductDetailsData(id);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingDetails = false;
      update();

      if (apiResponse.response!.data != null) {
        productDetailsData = apiResponse.response!.data!;
        productComparisonData1 = apiResponse.response!.data!;
        productComparisonData2 = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoadingDetails = false;
      update();
    }
  }

  Future<void> getComparisonData1(dynamic id) async {
    _isLoadingComparison1 = true;
    update();
    ApiResponse apiResponse = await productRepo.getProductDetailsData(id);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingComparison1 = false;
      update();

      if (apiResponse.response!.data != null) {
        productComparisonData1 = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoadingComparison1 = false;
      update();
    }
  }

  Future<void> getComparisonData2(dynamic id) async {
    _isLoadingComparison2 = true;
    update();
    ApiResponse apiResponse = await productRepo.getProductDetailsData(id);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingComparison2 = false;
      update();

      if (apiResponse.response!.data != null) {
        productComparisonData2 = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoadingComparison2 = false;
      update();
    }
  }

  Future<void> getProductAllVariation({dynamic id}) async {
    _isLoadingVariationAll = true;
    update();
    ApiResponse apiResponse = await productRepo.getProductAllVariation(
        id: id,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingVariationAll = false;
      update();

      if (apiResponse.response!.data != null) {
        productVariationAllData = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoadingVariationAll = false;
      update();
    }
  }

  Future<void> getProductVariationData({dynamic id,dynamic variationId}) async {
    _isLoadingVariation = true;
    update();
    ApiResponse apiResponse = await productRepo.getProductVariationData(
        id: id,
        variationId:variationId
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingVariation = false;
      update();

      if (apiResponse.response!.data != null) {
        productVariationData = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoadingVariation = false;
      update();
    }
  }

  /// Create a review
  Future<int?> createReview({
    dynamic productId,
    dynamic reviewUserName,
    dynamic reviewUserEmail,
    dynamic reviewText,
    dynamic rating,
  }) async {
    _isLoadingCreate = true;
    update();
    ApiResponse apiResponse = await productRepo.createReview(
      productId: productId,
      reviewText: reviewText,
      reviewUserName: reviewUserName,
      reviewUserEmail: reviewUserEmail,
      rating: rating,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 201) {
      _isLoadingCreate = false;
      update();

      if (apiResponse.response!.data != null) {
        update();
      }
      return apiResponse.response!.statusCode;
    } else {
      _isLoadingCreate = false;
      update();
    }
    return null;
  }

  /// Get all review data
  Future<void> getAllReviewData(dynamic id) async {
    _isLoadingReview = true;
    update();
    ApiResponse apiResponse = await productRepo.getAllReviewData(id);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingReview = false;
      update();

      if (apiResponse.response!.data != null) {
        reviewData = apiResponse.response!.data!;

        // Count the ratings
        for (var review in reviewData) {
          if (review["rating"] >= 1 && review["rating"] <= 5) {
            ratingCounts[review["rating"]] = ratingCounts[review["rating"]]! + 1;
          }
        }

        print(ratingCounts);
        update();
      }
    } else {
      _isLoadingReview = false;
      update();
    }
  }
}
