import 'dart:convert';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_strings.dart';
import 'package:toastification/toastification.dart';
import '../controller/cart_controller.dart';
import '../controller/order_controller.dart';
import '../controller/profile_controller.dart';
import '../utils/app_colors.dart';
import 'address_screen.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final bool isGuest;

  const CheckoutScreen({Key? key, this.isGuest = false}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // String selectedPaymentOption = "Cash";
  bool isLoading = true;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  late Razorpay razorpay;

  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: Colors.red,
    ));
  }

  void successHandler(PaymentSuccessResponse response) async {
    // confirm payment pop up
    final orderController = Get.find<OrderController>();
    final cartController = Get.find<CartController>();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getInt("customerId");
    //line_items
    List<Map<String, dynamic>> formatLineItems(List<CartItem> cartItems) {
      return cartItems.map((item) {
        // Create a base map with required fields
        final lineItem = {
          'product_id': item.product_id,
          'quantity': item.quantity,
        };

        // Check if variation_id is not null and meta_data is not empty
        if (item.variation_id != null && item.meta_data.isNotEmpty) {
          lineItem['variation_id'] = item.variation_id; // Include variation_id
          lineItem['meta_data'] = item.meta_data.map((entry) {
            String key = entry.keys.first; // Get the key
            String value = entry[key]; // Get the corresponding value
            return {
              'key': key, // Set the key
              'value': value, // Set the value
            };
          }).toList(); // Convert meta data to desired format
        }

        return lineItem;
      }).toList();
    }


    print("${preferences.getInt("customerId")}");
    print("${preferences.getString("firstName")}");
    print("${preferences.getString("lastName")}");
    print("${preferences.getString("address1")}");
    print("${preferences.getString("address2")}");
    print("${preferences.getString("city")}");
    print("${preferences.getString("postCode")}");
    print("${preferences.getString("state")}");
    print("${preferences.getString("phone")}");
    print("${formatLineItems}");


    orderController.createOrder(
        paymentName: "Razorpay",
        customerId: "${preferences.getInt("customerId")}",
        setPaid: true,
        lineItems: formatLineItems(cartController.cartItems),
        shipping: {
          "first_name": "${preferences.getString("firstName")}",
          "last_name": "${preferences.getString("firstName")}",
          "address_1": "${preferences.getString("address1")}",
          "address_2": "${preferences.getString("address2")}",
          "city": "${preferences.getString("city")}",
          "state": "${preferences.getString("state")}",
          "postcode": "${preferences.getString("postCode")}",
        },
        billing: "${preferences.getString("phone")}"
    ).then((value) {
      if (value == 201) {
        cartController.clearCart();
        Get.offAll(() => const OrderSuccessScreen());
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: Colors.green,
    ));
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: Colors.green,
    ));
  }

  // Save shipping data to SharedPreferences
  Future<void> saveShippingDataLocally({
    required String firstName,
    required String lastName,
    required String address1,
    required String address2,
    required String city,
    required String postCode,
    required String state,
    required String phone,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('address1', address1);
    await prefs.setString('address2', address2);
    await prefs.setString('city', city);
    await prefs.setString('postCode', postCode);
    await prefs.setString('state', state);
    await prefs.setString('phone', phone);
  }

  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    // TODO: implement initState
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   saveShippingDataLocally(
    //     firstName: 'Darshak',
    //     lastName: 'LastName',
    //     address1: 'LastName',
    //     address2: 'LastName',
    //     city: 'LastName',
    //     postCode: 'LastName',
    //     state: 'LastName',
    //     phone: 'LastName',
    //   );
    //
    //   loadAddress();
    //   // Get.find<ProfileController>().getProfileData().then((value) {
    //   //   saveShippingDataLocally(
    //   //        firstName: 'Darshak',
    //   //        lastName: 'LastName',
    //   //        address1: 'LastName',
    //   //        address2: 'LastName',
    //   //        city: 'LastName',
    //   //        postCode: 'LastName',
    //   //        state: 'LastName',
    //   //        phone: 'LastName',
    //   //   );
    //   // }).then((value) {
    //   //   loadAddress();
    //   // });
    // });

    // if (!widget.isGuest) {
    //   // Logged in user: load profile data
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     await profileController.getProfileData();
    //     // Assuming profileData is updated here
    //     if (profileController.profileData != null) {
    //       final shipping = profileController.profileData["shipping"];
    //       final billing = profileController.profileData["billing"];
    //
    //       setState(() {
    //         firstNameController.text = shipping["first_name"] ?? '';
    //         lastNameController.text = shipping["last_name"] ?? '';
    //         address1Controller.text = shipping["address_1"] ?? '';
    //         address2Controller.text = shipping["address_2"] ?? '';
    //         cityController.text = shipping["city"] ?? '';
    //         postcodeController.text = shipping["postcode"] ?? '';
    //         stateController.text = shipping["state"] ?? '';
    //         phoneController.text = billing["phone"] ?? '';
    //         isLoading = false;
    //       });
    //     }
    //   });
    // } else {
    //   // Guest user: empty fields, no profile load needed
    //   isLoading = false;
    // }
    if (!widget.isGuest) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await profileController.getProfileData();
        if (profileController.profileData != null) {
          final billing = profileController
              .profileData["billing"]; // Changed from shipping

          setState(() {
            firstNameController.text = billing["first_name"] ?? '';
            lastNameController.text = billing["last_name"] ?? '';
            emailController.text = billing["email"] ?? '';
            address1Controller.text = billing["address_1"] ?? '';
            address2Controller.text = billing["address_2"] ?? '';
            cityController.text = billing["city"] ?? '';
            postcodeController.text = billing["postcode"] ?? '';
            stateController.text = billing["state"] ?? '';
            phoneController.text = billing["phone"] ?? '';
            isLoading = false;
          });
        }
      });
    } else {
      isLoading = false;
    }


    super.initState();
  }

  Future<Map<String, String?>> loadGuestAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      "firstName": prefs.getString("firstName"),
      "lastName": prefs.getString("lastName"),
      "address1": prefs.getString("address1"),
      "address2": prefs.getString("address2"),
      "city": prefs.getString("city"),
      "postCode": prefs.getString("postCode"),
      "state": prefs.getString("state"),
      "phone": prefs.getString("phone"),
    };
  }

  loadAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("${preferences.getString("firstName")}");
    print("${preferences.getString("lastName")}");
    print("${preferences.getString("address1")}");
    print("${preferences.getString("address2")}");
    print("${preferences.getString("city")}");
    print("${preferences.getString("postCode")}");
    print("${preferences.getString("state")}");
    print("${preferences.getString("phone")}");
  }

  bool initializingPayment = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
        builder: (cartController) {
          return GetBuilder<ProfileController>(
              builder: (profileController) {
                return GetBuilder<OrderController>(
                    builder: (orderController) {
                      return Scaffold(
                        backgroundColor: AppColors.appWhiteColor,
                        appBar: AppBar(
                          backgroundColor: AppColors.appPrimaryColor,
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                              color: AppColors.appWhiteColor, size: 20,),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          title: Text('checkout'.tr, style: GoogleFonts.roboto(
                              color: AppColors.appWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),),
                        ),
                        body: !widget.isGuest &&
                            profileController.profileData != null &&
                            profileController.isLoading == false
                            ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Billing Address Section (Logged-in user)
                                if (profileController
                                    .profileData["billing"]["phone"]!
                                    .isNotEmpty &&
                                    profileController
                                        .profileData["billing"]["first_name"]!
                                        .isNotEmpty &&
                                    profileController
                                        .profileData["billing"]["last_name"]!
                                        .isNotEmpty &&
                                    profileController
                                        .profileData["billing"]["address_1"]!
                                        .isNotEmpty &&
                                    profileController
                                        .profileData["billing"]["city"]!
                                        .isNotEmpty &&
                                    profileController
                                        .profileData["billing"]["postcode"]!
                                        .isNotEmpty &&
                                    profileController
                                        .profileData["billing"]["state"]!
                                        .isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 4.0)
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'billing_address'.tr,
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Text("address".tr,
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight
                                                        .w500)),
                                            Text(
                                                " ${profileController
                                                    .profileData["billing"]["address_1"]} ${profileController
                                                    .profileData["billing"]["state"]}"),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Text("phone".tr,
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight
                                                        .w500)),
                                            Text(" ${profileController
                                                .profileData["billing"]["phone"]}"),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Text("postcode".tr,
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight
                                                        .w500)),
                                            Text(" ${profileController
                                                .profileData["billing"]["postcode"]}"),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              SharedPreferences preferences = await SharedPreferences
                                                  .getInstance();
                                              Get.to(() =>
                                                  AddressScreen(
                                                    firstName: preferences
                                                        .getString("firstName"),
                                                    lastName: preferences
                                                        .getString("lastName"),
                                                    address1: preferences
                                                        .getString("address1"),
                                                    address2: preferences
                                                        .getString("address2"),
                                                    city: preferences.getString(
                                                        "city"),
                                                    state: preferences
                                                        .getString("state"),
                                                    postcode: preferences
                                                        .getString("postCode"),
                                                    phone: preferences
                                                        .getString("phone"),
                                                  ));
                                            },
                                            style: ElevatedButton.styleFrom(),
                                            child: Text('change'.tr),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Center(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 16),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => AddressScreen());
                                          },
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              border: Border.all(
                                                  color: const Color(
                                                      0xffD7D7D7)),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  const Icon(Icons.add_circle,
                                                      color: AppColors
                                                          .appPrimaryColor),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    "add_billing".tr,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                const SizedBox(height: 24),

                                // Payment Method Section - Pickup Only
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 4.0)
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: AppColors.appPrimaryColor),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Pay with cash upon delivery',
                                        style: GoogleFonts.roboto(fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : widget.isGuest
                            ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Guest editable billing form
                                Text(
                                  'billing_address'.tr,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(controller: firstNameController,
                                    label: 'first_name'.tr),
                                const SizedBox(height: 12),
                                _buildTextField(controller: lastNameController,
                                    label: 'last_name'.tr),
                                const SizedBox(height: 12),
                                _buildTextField(
                                    controller: emailController,
                                    label: 'email'.tr,
                                    keyboardType: TextInputType.emailAddress
                                ),
                                const SizedBox(height: 12),

                                _buildTextField(controller: address1Controller,
                                    label: 'address_1'.tr),
                                const SizedBox(height: 12),
                                _buildTextField(controller: address2Controller,
                                    label: 'address_2'.tr),
                                const SizedBox(height: 12),
                                _buildTextField(controller: cityController,
                                    label: 'city'.tr),
                                const SizedBox(height: 12),
                                _buildTextField(controller: postcodeController,
                                    label: 'postcode'.tr),
                                const SizedBox(height: 12),
                                _buildTextField(controller: stateController,
                                    label: 'state'.tr),
                                const SizedBox(height: 12),
                                _buildTextField(controller: phoneController,
                                    label: 'phone'.tr,
                                    keyboardType: TextInputType.phone),
                                const SizedBox(height: 24),

                                // Payment Method Section - Pickup Only
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 4.0)
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: AppColors.appPrimaryColor),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Pay with cash upon delivery',
                                        style: GoogleFonts.roboto(fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : const Center(
                          child: SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                color: AppColors.appPrimaryColor),
                          ),
                        ),


                        bottomNavigationBar: BottomAppBar(
                            child:
                            orderController.isLoadingCreate == false ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // View Cart Button
                                Expanded(
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.appWhiteColor,
                                      border: Border.all(
                                          color: const Color(0xffE9E7EA)
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        'view_cart'.tr,
                                        style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors
                                              .appBlackColor, // Text color
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Proceed to Checkout Button


                                Expanded(
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.appPrimaryColor,
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        SharedPreferences preferences = await SharedPreferences.getInstance();

                                        if (widget.isGuest) {
                                          // Guest user validation - check text controllers
                                          if (firstNameController.text.trim().isEmpty ||
                                              lastNameController.text.trim().isEmpty ||
                                              emailController.text.trim().isEmpty ||
                                              address1Controller.text.trim().isEmpty ||
                                              // cityController.text.trim().isEmpty ||
                                              // postcodeController.text.trim().isEmpty ||
                                              // stateController.text.trim().isEmpty ||
                                              phoneController.text.trim().isEmpty) {

                                            toastification.show(
                                              alignment: Alignment.bottomCenter,
                                              type: ToastificationType.error,
                                              context: context,
                                              title: Text('Please fill all required fields', style: GoogleFonts.roboto(fontSize: 15)),
                                              autoCloseDuration: const Duration(seconds: 4),
                                            );
                                            return;
                                          }

                                          await _handleOrder(preferences, context, cartController, orderController, isGuest: true);

                                        } else {
                                          // Logged-in user validation - check billing data
                                          if (profileController.profileData != null &&
                                              profileController.profileData["billing"] != null &&
                                              profileController.profileData["billing"]["phone"] != null &&
                                              profileController.profileData["billing"]["phone"]!.isNotEmpty &&
                                              profileController.profileData["billing"]["email"] != null &&
                                              profileController.profileData["billing"]["email"]!.isNotEmpty &&
                                              profileController.profileData["billing"]["first_name"] != null &&
                                              profileController.profileData["billing"]["first_name"]!.isNotEmpty &&
                                              profileController.profileData["billing"]["last_name"] != null &&
                                              profileController.profileData["billing"]["last_name"]!.isNotEmpty &&
                                              profileController.profileData["billing"]["address_1"] != null &&
                                              profileController.profileData["billing"]["address_1"]!.isNotEmpty
                                          // &&
                                              // profileController.profileData["billing"]["city"] != null &&
                                              // profileController.profileData["billing"]["city"]!.isNotEmpty &&
                                              // profileController.profileData["billing"]["postcode"] != null &&
                                              // profileController.profileData["billing"]["postcode"]!.isNotEmpty &&
                                              // profileController.profileData["billing"]["state"] != null &&
                                              // profileController.profileData["billing"]["state"]!.isNotEmpty
                                          )
                                          {

                                            await _handleOrder(preferences, context, cartController, orderController);

                                          } else {
                                            toastification.show(
                                              alignment: Alignment.bottomCenter,
                                              type: ToastificationType.error,
                                              context: context,
                                              title: Text('Billing address missing', style: GoogleFonts.roboto(fontSize: 15)),
                                              autoCloseDuration: const Duration(seconds: 4),
                                            );
                                            return;
                                          }
                                        }
                                      },
                                      child: Text(
                                        'place_order'.tr,
                                        style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors
                                              .appWhiteColor, // Text color
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ) :
                            const Center(
                              child: SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    color: AppColors.appPrimaryColor
                                ),
                              ),
                            )
                        ),
                      );
                    }
                );
              }
          );
        }
    );
  }

  // Future<void> _handleOrder(SharedPreferences preferences, BuildContext context, CartController cartController, OrderController orderController, {bool isGuest = false}) async {
  //   List<Map<String, dynamic>> formatLineItems(List<CartItem> cartItems) {
  //     return cartItems.map((item) {
  //       final lineItem = {
  //         'product_id': item.product_id,
  //         'quantity': item.quantity,
  //       };
  //       if (item.variation_id != null && item.meta_data.isNotEmpty) {
  //         lineItem['variation_id'] = item.variation_id;
  //         lineItem['meta_data'] = item.meta_data.map((entry) {
  //           String key = entry.keys.first;
  //           String value = entry[key];
  //           return {'key': key, 'value': value};
  //         }).toList();
  //       }
  //       return lineItem;
  //     }).toList();
  //   }
  //
  //   // Use customerId or null for guests
  //   final customerId = isGuest ? null : "${preferences.getInt("customerId")}";
  //
  //   // FIX: Get shipping info from text controllers for guests
  //   final shipping = isGuest
  //       ? {
  //     "first_name": firstNameController.text.trim(),
  //     "last_name": lastNameController.text.trim(),
  //     "address_1": address1Controller.text.trim(),
  //     "address_2": address2Controller.text.trim(),
  //     "city": cityController.text.trim(),
  //     "state": stateController.text.trim(),
  //     "postcode": postcodeController.text.trim(),
  //   }
  //       : profileController.profileData["shipping"];
  //
  //   // FIX: Get phone from text controller for guests
  //   final billingPhone = isGuest
  //       ? phoneController.text.trim()
  //       : profileController.profileData["billing"]["phone"];
  //
  //   // OPTIONAL: Add validation for guest users
  //   if (isGuest) {
  //     // Check if required fields are filled
  //     if (firstNameController.text.trim().isEmpty ||
  //         lastNameController.text.trim().isEmpty ||
  //         address1Controller.text.trim().isEmpty ||
  //         cityController.text.trim().isEmpty ||
  //         postcodeController.text.trim().isEmpty ||
  //         stateController.text.trim().isEmpty ||
  //         phoneController.text.trim().isEmpty) {
  //
  //       toastification.show(
  //         alignment: Alignment.bottomCenter,
  //         type: ToastificationType.error,
  //         context: context,
  //         title: Text('Please fill all required fields', style: GoogleFonts.roboto(fontSize: 15)),
  //         autoCloseDuration: const Duration(seconds: 4),
  //       );
  //       return;
  //     }
  //
  //     // Save guest data to SharedPreferences for Razorpay and other uses
  //     await saveShippingDataLocally(
  //       firstName: firstNameController.text.trim(),
  //       lastName: lastNameController.text.trim(),
  //       address1: address1Controller.text.trim(),
  //       address2: address2Controller.text.trim(),
  //       city: cityController.text.trim(),
  //       postCode: postcodeController.text.trim(),
  //       state: stateController.text.trim(),
  //       phone: phoneController.text.trim(),
  //     );
  //   }
  //
  //   if (selectedPaymentOption == "Cash on Delivery") {
  //     orderController.createOrder(
  //       paymentName: "Cash on Delivery",
  //       customerId: customerId,
  //       setPaid: false,
  //       lineItems: formatLineItems(cartController.cartItems),
  //       shipping: shipping,
  //       billing: billingPhone,
  //     ).then((value) {
  //       if (value == 201) {
  //         cartController.clearCart();
  //         Get.offAll(() => const OrderSuccessScreen());
  //       }
  //     });
  //   } else if (selectedPaymentOption == "Stripe") {
  //     await makePayment(() {
  //       Navigator.pop(context);
  //       orderController.createOrder(
  //         paymentName: "Stripe",
  //         customerId: customerId,
  //         setPaid: true,
  //         lineItems: formatLineItems(cartController.cartItems),
  //         shipping: shipping,
  //         billing: billingPhone,
  //       ).then((value) {
  //         if (value == 201) {
  //           cartController.clearCart();
  //           Get.offAll(() => const OrderSuccessScreen());
  //         }
  //       });
  //     }, cartController.totalPrice.toInt().toString());
  //   } else if (selectedPaymentOption == "Razorpay") {
  //     var totalPriceInCents = (cartController.totalPrice * 100).toInt();
  //
  //     // For Razorpay, we need to save guest data to SharedPreferences first
  //     // because the success handler reads from SharedPreferences
  //     if (isGuest) {
  //       await preferences.setString('firstName', firstNameController.text.trim());
  //       await preferences.setString('lastName', lastNameController.text.trim());
  //       await preferences.setString('address1', address1Controller.text.trim());
  //       await preferences.setString('address2', address2Controller.text.trim());
  //       await preferences.setString('city', cityController.text.trim());
  //       await preferences.setString('postCode', postcodeController.text.trim());
  //       await preferences.setString('state', stateController.text.trim());
  //       await preferences.setString('phone', phoneController.text.trim());
  //     }
  //
  //     var options = {
  //       "key": AppStrings.razorPayKey,
  //       "amount": totalPriceInCents,
  //       "name": "Zilly Payment",
  //       "description": "Payment for Purchase the products",
  //       "currency": "USD",
  //       "prefill": {
  //         "contact": billingPhone,
  //         "email": preferences.getString("email_id") ?? "",
  //       }
  //     };
  //     razorpay.open(options);
  //   } else if (selectedPaymentOption == "Paypal") {
  //     var totalPriceInCents = (cartController.totalPrice * 100).toInt();
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => UsePaypal(
  //           sandboxMode: true,
  //           clientId: AppStrings.payPalClientId,
  //           secretKey: AppStrings.payPalClientSecret,
  //           returnURL: AppStrings.payPalReturnUrl,
  //           cancelURL: AppStrings.payPalCancelUrl,
  //           transactions: [
  //             {
  //               "amount": {
  //                 "total": "$totalPriceInCents",
  //                 "currency": "USD",
  //                 "details": {
  //                   "subtotal": '$totalPriceInCents',
  //                   "shipping": '0',
  //                   "shipping_discount": 0
  //                 }
  //               },
  //               "description": "Payment for product purchase",
  //             }
  //           ],
  //           note: "Contact us for any questions on your order.",
  //           onSuccess: (Map params) async {
  //             orderController.createOrder(
  //               paymentName: "Paypal",
  //               customerId: customerId,
  //               setPaid: true,
  //               lineItems: formatLineItems(cartController.cartItems),
  //               shipping: shipping,
  //               billing: billingPhone,
  //             ).then((value) {
  //               if (value == 201) {
  //                 cartController.clearCart();
  //                 Get.offAll(() => const OrderSuccessScreen());
  //               }
  //             });
  //           },
  //           onError: (error) => print("onError: $error"),
  //           onCancel: (params) => print('cancelled: $params'),
  //         ),
  //       ),
  //     );
  //   } else if (selectedPaymentOption == "PayStack") {
  //     var totalPriceInCents = (cartController.totalPrice * 100).toInt();
  //
  //     final request = PaystackTransactionRequest(
  //       reference: 'ps_${DateTime.now().microsecondsSinceEpoch}',
  //       secretKey: AppStrings.payStackSecretKey,
  //       email: preferences.getString("email_id") ?? "",
  //       amount: totalPriceInCents.toDouble(),
  //       currency: PaystackCurrency.usd,
  //       channel: [
  //         PaystackPaymentChannel.mobileMoney,
  //         PaystackPaymentChannel.card,
  //         PaystackPaymentChannel.ussd,
  //         PaystackPaymentChannel.bankTransfer,
  //         PaystackPaymentChannel.bank,
  //         PaystackPaymentChannel.qr,
  //         PaystackPaymentChannel.eft,
  //       ],
  //     );
  //
  //     setState(() => initializingPayment = true);
  //     final initializedTransaction = await PaymentService.initializeTransaction(request);
  //
  //     if (!mounted) return;
  //     setState(() => initializingPayment = false);
  //
  //     if (!initializedTransaction.status) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text(initializedTransaction.message),
  //       ));
  //       return;
  //     }
  //
  //     await PaymentService.showPaymentModal(
  //       context,
  //       transaction: initializedTransaction,
  //       callbackUrl: '...', // Your callback URL
  //     );
  //
  //     dynamic response = await PaymentService.verifyTransaction(
  //       paystackSecretKey: AppStrings.payStackSecretKey,
  //       initializedTransaction.data?.reference ?? request.reference,
  //     );
  //
  //     if (response.toMap()["data"]["status"].toString() == "success") {
  //       orderController.createOrder(
  //         paymentName: "PayStack",
  //         customerId: customerId,
  //         setPaid: true,
  //         lineItems: formatLineItems(cartController.cartItems),
  //         shipping: shipping,
  //         billing: billingPhone,
  //       ).then((value) {
  //         if (value == 201) {
  //           cartController.clearCart();
  //           Get.offAll(() => const OrderSuccessScreen());
  //         }
  //       });
  //     } else {
  //       print("Payment failed");
  //     }
  //   }
  // }
// REPLACE your current _handleOrder function with this corrected version:

  Future<void> _handleOrder(SharedPreferences preferences, BuildContext context,
      CartController cartController, OrderController orderController,
      {bool isGuest = false}) async {
    List<Map<String, dynamic>> formatLineItems(List<CartItem> cartItems) {
      return cartItems.map((item) {
        final lineItem = {
          'product_id': item.product_id,
          'quantity': item.quantity,
        };
        if (item.variation_id != null && item.meta_data.isNotEmpty) {
          lineItem['variation_id'] = item.variation_id;
          lineItem['meta_data'] = item.meta_data.map((entry) {
            String key = entry.keys.first;
            String value = entry[key];
            return {'key': key, 'value': value};
          }).toList();
        }
        return lineItem;
      }).toList();
    }

    final customerId = isGuest ? null : "${preferences.getInt("customerId")}";

    // Get billing info from text controllers for guests, from profile for logged-in users
    final billing = isGuest
        ? {
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      "address_1": address1Controller.text.trim(),
      "address_2": address2Controller.text.trim(),
      "email": emailController.text.trim(),
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "postcode": postcodeController.text.trim(),
      "phone": phoneController.text.trim(),
    }
        : profileController.profileData["billing"];

    // Validation for guest users
    if (isGuest) {
      if (firstNameController.text.trim().isEmpty ||
          lastNameController.text.trim().isEmpty ||
          address1Controller.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          phoneController.text.trim().isEmpty) {
        toastification.show(
          alignment: Alignment.bottomCenter,
          type: ToastificationType.error,
          context: context,
          title: Text('Please fill all required fields',
              style: GoogleFonts.roboto(fontSize: 15)),
          autoCloseDuration: const Duration(seconds: 4),
        );
        return;
      }

      // Save guest billing data to SharedPreferences
      await saveShippingDataLocally(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        address1: address1Controller.text.trim(),
        address2: address2Controller.text.trim(),
        city: cityController.text.trim(),
        postCode: postcodeController.text.trim(),
        state: stateController.text.trim(),
        phone: phoneController.text.trim(),
      );
    }

    // Create shipping object (same as billing for your use case)
    final shipping = {
      "first_name": billing["first_name"],
      "last_name": billing["last_name"],
      "address_1": billing["address_1"],
      "address_2": billing["address_2"],
      "city": billing["city"],
      "state": billing["state"],
      "postcode": billing["postcode"],
    };

    // Always use Cash on Delivery
    orderController.createOrder(
      paymentName: "Cash on Delivery",
      customerId: customerId,
      setPaid: false,
      lineItems: formatLineItems(cartController.cartItems),
      billing: billing,
      shipping: shipping,  // Now sending proper shipping object instead of just phone
    ).then((value) {
      if (value == 201) {
        cartController.clearCart();
        Get.offAll(() => const OrderSuccessScreen());
      }
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }


  // Widget _buildPaymentOption({required String title, required String value}) {
  //   bool isSelected = selectedPaymentOption == value;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedPaymentOption = value;
  //       });
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(bottom: 8.0),
  //       padding: const EdgeInsets.all(16.0),
  //       decoration: BoxDecoration(
  //         color: isSelected ? AppColors.appPrimaryColor : const Color(0xffF7F7F7),
  //         borderRadius: BorderRadius.circular(8.0),
  //
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(
  //             isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
  //             color: isSelected ? AppColors.appWhiteColor : Colors.grey,
  //           ),
  //           const SizedBox(width: 12),
  //           Text(
  //             title,
  //             style: GoogleFonts.roboto(
  //               fontSize: 14,
  //               color: isSelected ? AppColors.appWhiteColor : Colors.black,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Map<String, dynamic>? paymentIntent;
  //
  // Future<void> makePayment(dynamic onTap,dynamic amount) async {
  //   try {
  //     paymentIntent = await createPaymentIntent(amount, 'USD');
  //
  //     //STEP 2: Initialize Payment Sheet
  //     await Stripe.instance
  //         .initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //             paymentIntentClientSecret: paymentIntent![
  //             'client_secret'], //Gotten from payment intent
  //             style: ThemeMode.dark,
  //             merchantDisplayName: 'Test'))
  //         .then((value) {});
  //
  //     //STEP 3: Display Payment sheet
  //     displayPaymentSheet(onTap);
  //   } catch (err) {
  //     throw Exception(err);
  //   }
  // }
  //
  // displayPaymentSheet(dynamic onTap) async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       if (kDebugMode) {
  //         print("success");
  //       }
  //
  //       showModalBottomSheet(
  //         context: context,
  //         isDismissible: false, // Set to false if you don't want the bottom sheet to be dismissible
  //         builder: (_) => Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.symmetric(
  //               horizontal: 16,vertical: 32
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Icon(
  //                 Icons.check_circle,
  //                 color: Colors.green,
  //                 size: 50,
  //               ),
  //               const SizedBox(height: 10.0),
  //               Text(
  //                 "Payment Successful!",
  //                 style: GoogleFonts.roboto(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500
  //                 ),
  //               ),
  //               const SizedBox(height: 24.0), // Add spacing between the text and the button
  //               MaterialButton(
  //                 minWidth: double.infinity,
  //                 height: 50,
  //                 color: AppColors.appPrimaryColor,
  //                 onPressed: onTap,
  //                 child: Text(
  //                   "Proceed Order",
  //                   style: GoogleFonts.roboto(
  //                     fontSize: 15,
  //                     color: AppColors.appWhiteColor
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 20.0), // Add spacing between the text and the button
  //             ],
  //           ),
  //         ),
  //       );
  //
  //
  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       throw Exception(error);
  //     });
  //   } on StripeException catch (e) {
  //     if (kDebugMode) {
  //       print('Error is:---> $e');
  //     }
  //     const AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.cancel,
  //                 color: Colors.red,
  //               ),
  //               Text("Payment Failed"),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('$e');
  //     }
  //   }
  // }
  //
  // dynamic paymentId;
  //
  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     //Request body
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //     };
  //
  //     //Make post request to Stripe
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );
  //     if (kDebugMode) {
  //       print("Payment response>>> ${json.decode(response.body)}");
  //     }
  //     dynamic apiResponse = json.decode(response.body);
  //     paymentId = apiResponse["id"];
  //     if (kDebugMode) {
  //       print("Payment id>>> $paymentId");
  //     }
  //     return json.decode(response.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }

  calculateAmount(String amount) {
    final calculatedAmount = int.parse(amount.toString()) * 100;
    return calculatedAmount.toString();
  }
}


