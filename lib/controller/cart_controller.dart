import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  Rx<int> itemCount = 0.obs;
  Rx<double> totalPrice = 0.0.obs;

  var compareItems = <CartItem>[].obs;

  void addItemToCompare(CartItem item) {
    // Check if the comparison list already has 2 items
    if (compareItems.length >= 2) {
      // If there are already 2 items in the compare list, show a message
      Get.snackbar(
        'Limit Reached',
        'You can only compare up to 2 items.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.15),
      );
      return; // Exit the function without adding the new item
    }

    // Check if the item is already in the compare list by product_id
    if (!compareItems.any((existingItem) => existingItem.product_id == item.product_id)) {
      compareItems.add(item);
      Get.snackbar(
        'Added to Compare',
        '${item.name} has been added to your compare list.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white70,
      );
    } else {
      Get.snackbar(
        'Already in Compare',
        '${item.name} is already in your compare list.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.15),
      );
    }
    update(); // Update the state to refresh the UI
  }


  void removeItemFromCompare(String productId) {
    // Find the item in the compare list
    var itemToRemove = compareItems.firstWhereOrNull((item) => item.product_id.toString() == productId);

    if (itemToRemove != null) {
      compareItems.remove(itemToRemove);
      Get.snackbar('Removed from Compare', '${itemToRemove.name} has been removed from your compare list.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white70);
    } else {
      Get.snackbar('Item Not Found', 'The item could not be found in your compare list.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.15));
    }
    update();
  }

  // Wishlist functions (add, remove, clear, save/load wishlist) remain the same.

  Future<void> saveCompareList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> items = compareItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('compare', items);
  }

  Future<void> loadCompareList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList('compare');
    if (items != null) {
      compareItems.value = items.map((item) => CartItem.fromJson(jsonDecode(item))).toList();
    }
  }

  void removeAllItemsFromCompare() {
    compareItems.clear();
    Get.snackbar('Compare List Cleared', 'All items have been removed from your compare list.',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white70);
    update();
  }


  @override
  void onInit() {
    super.onInit();
    calculateTotals();
    loadWishlist();
  }

  void addItemToCart(CartItem item) {
    var existingItem = cartItems.firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id);
    if (existingItem != null) {
      existingItem.quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
    calculateTotals();
    update();
  }

  // Function to decrement the quantity of an item in the cart
  void decreaseItemQuantity(CartItem item) {
    // Find the item in the cart
    var cartItem = cartItems.firstWhereOrNull((cartItem) => cartItem.product_id == item.product_id);

    if (cartItem != null) {
      // Decrease the quantity
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
        cartItems.refresh();
      } else {
        // Remove the item if quantity goes to zero
        cartItems.remove(cartItem);
      }
      // Recalculate totals
      calculateTotals();
    }
    update();
  }


  void removeItemFromCart(String id) {
    cartItems.removeWhere((cartItem) => cartItem.product_id == id);
    calculateTotals();
    update();
  }



  void updateItemQuantity(String id, int quantity) {
    var item = cartItems.firstWhereOrNull((cartItem) => cartItem.product_id == id);
    if (item != null) {
      item.quantity = quantity;
      if (item.quantity <= 0) {
        cartItems.remove(item);
      } else {
        cartItems.refresh();
      }
      calculateTotals();
    }
    update();
  }

  void calculateTotals() {
    itemCount.value = cartItems.fold(0, (sum, item) => sum + item.quantity);
    totalPrice.value = cartItems.fold(0.0, (sum, item) => sum + (double.parse(item.price.toString()) * item.quantity));
    update();
  }

  void clearCart() {
    cartItems.clear();
    calculateTotals();
    update();
  }

  void removeSingleItemFromCart(String id) {
    cartItems.removeWhere((cartItem) => cartItem.product_id == id);
    calculateTotals();
    update();
  }

  void removeAllItemsFromCart() {
    cartItems.clear();
    calculateTotals();
    update();
  }

  var wishlistItems = <CartItem>[].obs;

  void addToWishlist(CartItem item) {
    // Check if the item already exists based on product_id
    if (!wishlistItems.any((existingItem) => existingItem.product_id == item.product_id)) {
      wishlistItems.add(item);
      saveWishlist(); // Save wishlist after adding an item
      Get.snackbar('Added to Wishlist', '${item.name} has been added to your wishlist.',snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.white70);
    } else {
      Get.snackbar('Already in Wishlist', '${item.name} is already in your wishlist.',snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red.withOpacity(0.15));
    }
  }

  void removeFromWishlist(String productId) {
    // Find the item in the wishlist by product_id
    dynamic itemToRemove = wishlistItems.firstWhereOrNull((item) => item.product_id.toString() == productId,
    );

    if (itemToRemove != null) {
      wishlistItems.remove(itemToRemove);
      saveWishlist(); // Save wishlist after removing an item
      Get.snackbar('Removed from Wishlist', '${itemToRemove.name} has been removed from your wishlist.',snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.white70);
      loadWishlist();
      update();
    } else {
      Get.snackbar('Item Not Found', 'The item could not be found in your wishlist.',snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red.withOpacity(0.15));
    }
  }

  void clearWishlist() {
    wishlistItems.clear(); // Clear the wishlist
    saveWishlist(); // Save the empty wishlist
    loadWishlist();
    update();
    Get.snackbar('Wishlist Cleared', 'All items have been removed from your wishlist.');
  }


  Future<void> saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> items = wishlistItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('wishlist', items);
  }

  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList('wishlist');
    if (items != null) {
      wishlistItems.value = items.map((item) => CartItem.fromJson(jsonDecode(item))).toList();
    }
  }

}

class CartItem {
   dynamic product_id;
   dynamic name;
   dynamic image;
   dynamic price;
   dynamic variation_id;
   dynamic meta_data;
   int quantity;

  CartItem({
    required this.product_id,
    required this.name,
    required this.image,
    required this.price,
    this.variation_id,
    this.meta_data,
    this.quantity = 1,
  });

   // Convert a CartItem into a Map. The keys must correspond to the names of the
   // fields in the JSON.
   Map<String, dynamic> toJson() {
     return {
       'product_id': product_id,
       'name': name,
       'image': image,
       'price': price,
       'variation_id': variation_id,
       'meta_data': meta_data,
       'quantity': quantity,
     };
   }

   // Extract a CartItem object from a Map.
   factory CartItem.fromJson(Map<String, dynamic> json) {
     return CartItem(
       product_id: json['product_id'],
       name: json['name'],
       image: json['image'],
       price: json['price'],
       variation_id: json['variation_id'],
       meta_data: json['meta_data'],
       quantity: json['quantity'] ?? 1,
     );
   }

}