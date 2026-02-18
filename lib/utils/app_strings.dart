class AppStrings{

  //website
  //https://www.radiustheme.com/demo/wordpress/themes/autonex
  static const String token = '';
  static const String appVersion = '1.0.0';
  static const String website = 'https://www.radiustheme.com/demo/wordpress/themes/autonex';

  /// Base URL
  static const String baseUrl = 'https://liquor.marsintel.com/wp-json/wc/v3';

  /// zilly keys
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

  //Payment Gateway setup

  ///Razorpay
  static const String razorPayKey = 'rzp_test_398G8BZ16LybQw';

  ///Paypal
  static const String payPalReturnUrl = 'https://sandbox.paypal.com';
  static const String payPalCancelUrl = 'https://sandbox.paypal.com';
  static const String payPalClientId = 'Acop-7ez_Sqhs225fKVtS6Y-a81MaDa4Om89ktrPgcdX8uK_ZhDZDDUTgr9o71TppjBg_w_ddOljECqh';
  static const String payPalClientSecret = 'EE0Q60cULg_1b6g7xKM_gj2rtrTuHmslkvNMtdb8iuXWwXfW5wiRo6rCfwN0Gl8vV-6PHLygwYQyYFWn';

  ///PayStack
  static const String payStackSecretKey = 'sk_test_226ab1933714f5d5625989809c62567de30f8f5c';


}