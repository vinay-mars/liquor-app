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
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentOption = "Cash";


  late Razorpay razorpay;
  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: Colors.red,
    ));
  }
  void successHandler(PaymentSuccessResponse response) async{

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
      if(value==201){
        cartController.clearCart();
        Get.offAll(()=> const OrderSuccessScreen());
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProfileController>().getProfileData().then((value) {
        saveShippingDataLocally(
             firstName: profileController.profileData["shipping"]["first_name"],
             lastName: profileController.profileData["shipping"]["last_name"],
             address1: profileController.profileData["shipping"]["address_1"],
             address2: profileController.profileData["shipping"]["address_2"],
             city: profileController.profileData["shipping"]["city"],
             postCode: profileController.profileData["shipping"]["postcode"],
             state: profileController.profileData["shipping"]["state"],
             phone: profileController.profileData["billing"]["phone"],
        );
      }).then((value) {
        loadAddress();
      });
    });
    super.initState();
  }

  loadAddress()async{
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
                        icon: const Icon(Icons.arrow_back_ios_new_outlined,color: AppColors.appWhiteColor,size: 20,),
                        onPressed: (){
                          Get.back();
                        },
                      ),
                      title: Text('checkout'.tr,style: GoogleFonts.roboto(
                          color: AppColors.appWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),),
                    ),
                  body: profileController.isLoading==false && profileController.profileData!=null?
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      
                          // Shipping Address Section
                          if (profileController.profileData["billing"]["phone"]!.isNotEmpty &&
                              profileController.profileData["shipping"]["first_name"]!.isNotEmpty &&
                              profileController.profileData["shipping"]["last_name"]!.isNotEmpty &&
                              profileController.profileData["shipping"]["address_1"]!.isNotEmpty &&
                              profileController.profileData["shipping"]["city"]!.isNotEmpty &&
                              profileController.profileData["shipping"]["postcode"]!.isNotEmpty &&
                              profileController.profileData["shipping"]["state"]!.isNotEmpty) Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4.0)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'shipping_address'.tr,
                                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                      
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Text("address".tr,style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500
                                    ),),
                                    Text(" ${profileController.profileData["shipping"]["address_1"]} ${profileController.profileData["shipping"]["state"]}"),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Text("phone".tr,style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500
                                    ),),
                                    Text(" ${profileController.profileData["billing"]["phone"]}"),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Text("postcode".tr,style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500
                                    ),),
                                    Text(" ${profileController.profileData["shipping"]["postcode"]}"),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      SharedPreferences preferences = await SharedPreferences.getInstance();
                                      print("${preferences.getString("firstName")}");
                                      print("${preferences.getString("lastName")}");
                                      print("${preferences.getString("address1")}");
                                      print("${preferences.getString("address2")}");
                                      print("${preferences.getString("city")}");
                                      print("${preferences.getString("postCode")}");
                                      print("${preferences.getString("state")}");
                                      print("${preferences.getString("phone")}");
                                     Get.to(()=> AddressScreen(
                                       firstName: preferences.getString("firstName"),
                                       lastName: preferences.getString("lastName"),
                                       address1: preferences.getString("address1"),
                                       address2: preferences.getString("address2"),
                                       city: preferences.getString("city"),
                                       state: preferences.getString("state"),
                                       postcode: preferences.getString("postCode"),
                                       phone: preferences.getString("phone"),
                                     ));
                                    },
                                    style: ElevatedButton.styleFrom(),
                                    child: Text('change'.tr),
                                  ),
                                ),
                              ],
                            ),
                          ) else Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16,),
                                    GestureDetector(
                                      onTap: (){
                                        Get.to(()=> AddressScreen());
                                      },
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color(0xffD7D7D7)
                                          )
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.add_circle,color: AppColors.appPrimaryColor,),
                                              const SizedBox(width: 6,),
                                              Text("add_shipping".tr,
                                              style: GoogleFonts.roboto(
                                                fontSize: 16,
                                              ),
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
                      
                          // Payment Method Section
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4.0)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'payment_method'.tr,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildPaymentOption(
                                  title: 'Cash on Delivery',
                                  value: 'Cash on Delivery',
                                ),
                                const SizedBox(height: 8),
                                _buildPaymentOption(
                                  title: 'Stripe',
                                  value: 'Stripe',
                                ),
                                const SizedBox(height: 8),
                                _buildPaymentOption(
                                  title: 'Razorpay',
                                  value: 'Razorpay',
                                ),
                                const SizedBox(height: 8),
                                _buildPaymentOption(
                                  title: 'Paypal',
                                  value: 'Paypal',
                                ),
                                const SizedBox(height: 8),
                                _buildPaymentOption(
                                  title: 'PayStack',
                                  value: 'PayStack',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ):
                  const Center(
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.appPrimaryColor
                      ),
                    ),
                  ),
                  bottomNavigationBar: BottomAppBar(
                    child:
                    orderController.isLoadingCreate==false?
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
                              borderRadius: BorderRadius.circular(8), // Rounded corners
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
                                  color: AppColors.appBlackColor, // Text color
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
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                            ),
                            child: TextButton(
                              onPressed: () async {
                                // Checkout logic here
                                if( profileController.profileData["billing"]["phone"]!.isNotEmpty &&
                                    profileController.profileData["shipping"]["first_name"]!.isNotEmpty &&
                                    profileController.profileData["shipping"]["last_name"]!.isNotEmpty &&
                                    profileController.profileData["shipping"]["address_1"]!.isNotEmpty &&
                                    profileController.profileData["shipping"]["city"]!.isNotEmpty &&
                                    profileController.profileData["shipping"]["postcode"]!.isNotEmpty &&
                                    profileController.profileData["shipping"]["state"]!.isNotEmpty ) {
                                  SharedPreferences preferences = await SharedPreferences
                                      .getInstance();
                                  preferences.getInt("customerId");

                                  // Line items
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

                                  // Cash on delivery
                                  if (selectedPaymentOption == "Cash on Delivery") {
                                    print("Cash on Delivery");
                                    print("Customer id >> ${preferences.getInt("customerId")}");
                                    print("item >> ${formatLineItems(cartController.cartItems)}");
                                    orderController.createOrder(
                                      paymentName: "Cash on Delivery",
                                      customerId: "${preferences.getInt("customerId")}",
                                      setPaid: false,
                                      lineItems: formatLineItems(cartController.cartItems), // Format line items including meta_data
                                      shipping: {
                                        "first_name": profileController.profileData["shipping"]["first_name"],
                                        "last_name": profileController.profileData["shipping"]["last_name"],
                                        "address_1": profileController.profileData["shipping"]["address_1"],
                                        "address_2": profileController.profileData["shipping"]["address_2"],
                                        "city": profileController.profileData["shipping"]["city"],
                                        "state": profileController.profileData["shipping"]["state"],
                                        "postcode": profileController.profileData["shipping"]["postcode"],
                                      },
                                      billing: profileController.profileData["billing"]["phone"],
                                    ).then((value) {
                                      if (value == 201) {
                                        cartController.clearCart();
                                        Get.offAll(() => const OrderSuccessScreen());
                                      }
                                    });
                                  }

                                  //Stripe payment
                                  else if (selectedPaymentOption == "Stripe") {
                                    if (kDebugMode) {
                                      print("do stripe payment");
                                    }
                                    await makePayment(() {
                                      Navigator.pop(context);
                                      orderController.createOrder(
                                          paymentName: "Stripe",
                                          customerId: "${preferences.getInt(
                                              "customerId")}",
                                          setPaid: true,
                                          lineItems: formatLineItems(
                                              cartController.cartItems),
                                          shipping: {
                                            "first_name": profileController
                                                .profileData["shipping"]["first_name"],
                                            "last_name": profileController
                                                .profileData["shipping"]["last_name"],
                                            "address_1": profileController
                                                .profileData["shipping"]["address_1"],
                                            "address_2": profileController
                                                .profileData["shipping"]["address_2"],
                                            "city": profileController
                                                .profileData["shipping"]["city"],
                                            "state": profileController
                                                .profileData["shipping"]["state"],
                                            "postcode": profileController
                                                .profileData["shipping"]["postcode"],
                                          },
                                          billing: profileController
                                              .profileData["billing"]["phone"]
                                      ).then((value) {
                                        if (value == 201) {
                                          cartController.clearCart();
                                          Get.offAll(() => const OrderSuccessScreen());
                                        }
                                      });
                                    },
                                    cartController.totalPrice.toInt().toString()
                                    );
                                  }

                                  //Razorpay payment
                                  else
                                  if (selectedPaymentOption == "Razorpay") {
                                    if (kDebugMode) {
                                      print("do razorpay payment");
                                    }
                                    var totalPriceInCents = (cartController
                                        .totalPrice * 100)
                                        .toInt(); // Convert dollars to cents

                                    var options = {
                                      "key": AppStrings.razorPayKey,
                                      "amount": totalPriceInCents,
                                      "name": "Zilly Payment",
                                      "description": "Payment for Purchase the products",
                                      "currency": "USD",
                                      "prefill": {
                                        "contact": "${preferences.getString(
                                            "phone")}",
                                        "email": "${preferences.getString(
                                            "email_id")}",
                                      }
                                    };

                                    razorpay.open(options);
                                  }

                                  //Paypal payment
                                  else if (selectedPaymentOption == "Paypal") {
                                    if (kDebugMode) {
                                      print("do paypal payment");
                                    }

                                    var totalPriceInCents = (cartController
                                        .totalPrice * 100).toInt();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => UsePaypal(
                                            sandboxMode: true,
                                            clientId:
                                            AppStrings.payPalClientId,
                                            secretKey:
                                            AppStrings.payPalClientSecret,
                                            returnURL: AppStrings.payPalReturnUrl,
                                            cancelURL: AppStrings.payPalCancelUrl,
                                            transactions:   [
                                              {
                                                "amount": {
                                                  "total": "${totalPriceInCents}",
                                                  "currency": "USD",
                                                  "details": {
                                                    "subtotal": '${totalPriceInCents}',
                                                    "shipping": '0',
                                                    "shipping_discount": 0
                                                  }
                                                },
                                                "description": "Payment for product purchase",
                                              }
                                            ],
                                            note: "Contact us for any questions on your order.",
                                            onSuccess: (Map params) async {
                                              print("onSuccess: $params");
                                              print("Payment success");
                                              orderController.createOrder(
                                                  paymentName: "Paypal",
                                                  customerId: "${preferences.getInt("customerId")}",
                                                  setPaid: true,
                                                  lineItems: formatLineItems(
                                                      cartController
                                                          .cartItems),
                                                  shipping: {
                                                    "first_name": profileController
                                                        .profileData["shipping"]["first_name"],
                                                    "last_name": profileController
                                                        .profileData["shipping"]["last_name"],
                                                    "address_1": profileController
                                                        .profileData["shipping"]["address_1"],
                                                    "address_2": profileController
                                                        .profileData["shipping"]["address_2"],
                                                    "city": profileController
                                                        .profileData["shipping"]["city"],
                                                    "state": profileController
                                                        .profileData["shipping"]["state"],
                                                    "postcode": profileController
                                                        .profileData["shipping"]["postcode"],
                                                  },
                                                  billing: profileController
                                                      .profileData["billing"]["phone"]
                                              ).then((value) {
                                                if (value == 201) {
                                                  cartController
                                                      .clearCart();
                                                  Get
                                                      .offAll(() => const OrderSuccessScreen());
                                                }
                                              });
                                            },
                                            onError: (error) {
                                              print("onError: $error");
                                            },
                                            onCancel: (params) {
                                              print('cancelled: $params');
                                            }),
                                      ),
                                    );
                                  }

                                  //Paypal payment
                                  else
                                  if (selectedPaymentOption == "PayStack") {
                                    if (kDebugMode) {
                                      print("do PayStack payment");
                                    }

                                    var totalPriceInCents = (cartController
                                        .totalPrice * 100).toInt();

                                    final request = PaystackTransactionRequest(
                                      reference: 'ps_${DateTime
                                          .now()
                                          .microsecondsSinceEpoch}',
                                      secretKey: AppStrings.payStackSecretKey,
                                      email: '${preferences.getString("email_id")}',
                                      amount: totalPriceInCents.toDouble(),
                                      currency: PaystackCurrency.usd,
                                      channel: [
                                        PaystackPaymentChannel.mobileMoney,
                                        PaystackPaymentChannel.card,
                                        PaystackPaymentChannel.ussd,
                                        PaystackPaymentChannel.bankTransfer,
                                        PaystackPaymentChannel.bank,
                                        PaystackPaymentChannel.qr,
                                        PaystackPaymentChannel.eft,
                                      ],
                                    );

                                    setState(() => initializingPayment = true);
                                    final initializedTransaction =
                                        await PaymentService
                                        .initializeTransaction(request);

                                    if (!mounted) return;
                                    setState(() => initializingPayment = false);

                                    if (!initializedTransaction.status) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            initializedTransaction.message),
                                      ));

                                      return;
                                    }

                                    await PaymentService.showPaymentModal(
                                      context,
                                      transaction: initializedTransaction,
                                      // Callback URL must match the one specified on your paystack dashboard,
                                      callbackUrl: '...',
                                    );

                                    dynamic response = await PaymentService
                                        .verifyTransaction(
                                      paystackSecretKey: AppStrings.payStackSecretKey,
                                      initializedTransaction.data?.reference ??
                                          request.reference,
                                    );

                                    print("response ${response.toMap()}");

                                    if(response.toMap()["data"]["status"].toString()=="success"){
                                      orderController.createOrder(
                                          paymentName: "PayStack",
                                          customerId: "${preferences
                                              .getInt(
                                              "customerId")}",
                                          setPaid: true,
                                          lineItems: formatLineItems(
                                              cartController
                                                  .cartItems),
                                          shipping: {
                                            "first_name": profileController
                                                .profileData["shipping"]["first_name"],
                                            "last_name": profileController
                                                .profileData["shipping"]["last_name"],
                                            "address_1": profileController
                                                .profileData["shipping"]["address_1"],
                                            "address_2": profileController
                                                .profileData["shipping"]["address_2"],
                                            "city": profileController
                                                .profileData["shipping"]["city"],
                                            "state": profileController
                                                .profileData["shipping"]["state"],
                                            "postcode": profileController
                                                .profileData["shipping"]["postcode"],
                                          },
                                          billing: profileController
                                              .profileData["billing"]["phone"]
                                      ).then((value) {
                                        if (value == 201) {
                                          cartController
                                              .clearCart();
                                          Get
                                              .offAll(() => const OrderSuccessScreen());
                                        }
                                      });
                                    }
                                    else{
                                      print("Payment failed");
                                    }


                                  }

                                }else{
                                  toastification.show(
                                    alignment: Alignment.bottomCenter,
                                    type: ToastificationType.error,
                                    context: context,
                                    title: Text('Shipping address missing',style: GoogleFonts.roboto(
                                      fontSize: 15
                                    ),),
                                    autoCloseDuration: const Duration(seconds: 4),
                                  );

                                }

                              },
                              child: Text(
                                'place_order'.tr,
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appWhiteColor, // Text color
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ):
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

  Widget _buildPaymentOption({required String title, required String value}) {
    bool isSelected = selectedPaymentOption == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentOption = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appPrimaryColor : const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(8.0),

        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.appWhiteColor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: isSelected ? AppColors.appWhiteColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(dynamic onTap,dynamic amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              merchantDisplayName: 'Test'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(onTap);
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet(dynamic onTap) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        if (kDebugMode) {
          print("success");
        }

        showModalBottomSheet(
          context: context,
          isDismissible: false, // Set to false if you don't want the bottom sheet to be dismissible
          builder: (_) => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 16,vertical: 32
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Payment Successful!",
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 24.0), // Add spacing between the text and the button
                MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  color: AppColors.appPrimaryColor,
                  onPressed: onTap,
                  child: Text(
                    "Proceed Order",
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: AppColors.appWhiteColor
                    ),
                  ),
                ),
                const SizedBox(height: 20.0), // Add spacing between the text and the button
              ],
            ),
          ),
        );


        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('Error is:---> $e');
      }
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  dynamic paymentId;

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      if (kDebugMode) {
        print("Payment response>>> ${json.decode(response.body)}");
      }
      dynamic apiResponse = json.decode(response.body);
      paymentId = apiResponse["id"];
      if (kDebugMode) {
        print("Payment id>>> $paymentId");
      }
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = int.parse(amount.toString()) * 100;
    return calculatedAmount.toString();
  }
}


