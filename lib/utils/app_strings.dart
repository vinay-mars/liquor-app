class AppStrings{

  static const String token = '';
  static const String appVersion = '1.0.0';
  static const String website = 'https://pringlesfinewine.com';

  /// Base URL
  static const String baseUrl = '$website/wp-json/wc/v3';

  /// WooCommerce REST API keys
  static const String key = 'ck_7fc9fac31eda7c941a287dff12748fc169623715';
  static const String secret = 'cs_76bbe8b329b75e526eed2950dc0b0a76e6c42d80';

  ///End Point
  static const String generalSettingsUrl = '/settings/general';
  static const String productUrl = '/products?';
  static const String productDetailsUrl = '/products/';
  static const String productCategoriesUrl = '/products/categories?parent=0';
  static const String categoryWiseProductUrl = '/products?category=';
  static const String registerUrl = '/customers';
  static const String loginUrl = '/wp-json/jwt-auth/v1/token';
  static const String profileUrl = '/customers/';
  static const String createOrderUrl = '/orders';
  static const String ordersUrl = '/orders/';
  static const String createReviewUrl = '/products/reviews';
  static const String getAllReviewUrl = '/products/reviews?';
  static const String relatedProducts = '/products?include=';

}