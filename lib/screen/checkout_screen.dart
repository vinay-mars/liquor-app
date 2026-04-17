import 'dart:convert';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLoading = true;

  final Map<String, String?> _fieldErrors = {};

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();




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
    await prefs.setString('guestEmail', emailController.text.trim());
  }

  final profileController = Get.find<ProfileController>();

  @override
  void initState() {

    if (!widget.isGuest) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await profileController.getProfileData();
        if (profileController.profileData != null) {
          final billing = profileController.profileData["billing"];
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
                          color: AppColors.appWhiteColor, size: 20),
                      onPressed: () => Get.back(),
                    ),
                    title: Text(
                      'checkout'.tr,
                      style: GoogleFonts.roboto(
                        color: AppColors.appWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                          if (profileController.profileData["billing"]
                          ["phone"]!
                              .isNotEmpty &&
                              profileController.profileData["billing"]
                              ["first_name"]!
                                  .isNotEmpty &&
                              profileController.profileData["billing"]
                              ["last_name"]!
                                  .isNotEmpty &&
                              profileController.profileData["billing"]
                              ["address_1"]!
                                  .isNotEmpty &&
                              profileController.profileData["billing"]
                              ["city"]!
                                  .isNotEmpty &&
                              profileController.profileData["billing"]
                              ["postcode"]!
                                  .isNotEmpty &&
                              profileController.profileData["billing"]
                              ["state"]!
                                  .isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 4.0,
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'billing_address'.tr,
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text("address".tr,
                                          style: GoogleFonts.roboto(
                                              fontWeight:
                                              FontWeight.w500)),
                                      Text(
                                          " ${profileController.profileData["billing"]["address_1"]} ${profileController.profileData["billing"]["state"]}"),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text("phone".tr,
                                          style: GoogleFonts.roboto(
                                              fontWeight:
                                              FontWeight.w500)),
                                      Text(
                                          " ${profileController.profileData["billing"]["phone"]}"),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text("postcode".tr,
                                          style: GoogleFonts.roboto(
                                              fontWeight:
                                              FontWeight.w500)),
                                      Text(
                                          " ${profileController.profileData["billing"]["postcode"]}"),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        SharedPreferences preferences = await SharedPreferences.getInstance();
                                        Get.to(() => AddressScreen(
                                          firstName: preferences.getString("firstName"),
                                          lastName: preferences.getString("lastName"),
                                          address1: preferences.getString("address1"),
                                          address2: preferences.getString("address2"),
                                          city: preferences.getString("city"),
                                          state: preferences.getString("state"),
                                          postcode: preferences.getString("postCode"),
                                          phone: preferences.getString("phone"),
                                        ))?.then((_) async {        // ADD FROM HERE
                                          await profileController.getProfileData();
                                          setState(() {});
                                        });                        // TO HERE
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
                                    onTap: () =>
                                        Get.to(() => AddressScreen()),
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                            const Color(0xffD7D7D7)),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          _buildCodBadge(),
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
                          Text(
                            'billing_address'.tr,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: firstNameController,
                            label: 'First Name',
                            isRequired: true,
                            errorKey: 'firstName',
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: lastNameController,
                            label: 'Last Name',
                            isRequired: true,
                            errorKey: 'lastName',
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: emailController,
                            label: 'Email Address',
                            keyboardType: TextInputType.emailAddress,
                            isRequired: true,
                            errorKey: 'email',
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: address1Controller,
                            label: 'Address Line 1',
                            isRequired: true,        // ← fix
                            errorKey: 'address1',   // ← fix, was missing
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: address2Controller,
                            label: 'address_2'.tr,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: cityController,
                            label: 'city'.tr,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: postcodeController,
                            label: 'postcode'.tr,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: stateController,
                            label: 'state'.tr,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: phoneController,
                            label: 'Phone',
                            keyboardType: TextInputType.phone,
                            isRequired: true,
                            errorKey: 'phone',
                          ),
                          const SizedBox(height: 24),
                          _buildCodBadge(),
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
                    child: orderController.isLoadingCreate == false
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.appWhiteColor,
                              border: Border.all(
                                  color: const Color(0xffE9E7EA)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'view_cart'.tr,
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appBlackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.appPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                SharedPreferences preferences =
                                await SharedPreferences.getInstance();

                                if (widget.isGuest) {
                                  // Per-field validation
                                  bool hasErrors = false;
                                  final newErrors = <String, String?>{};

                                  if (firstNameController.text
                                      .trim()
                                      .isEmpty) {
                                    newErrors['firstName'] =
                                    'Billing First Name is a required field.';
                                    hasErrors = true;
                                  }
                                  if (lastNameController.text
                                      .trim()
                                      .isEmpty) {
                                    newErrors['lastName'] =
                                    'Billing Last Name is a required field.';
                                    hasErrors = true;
                                  }
                                  if (emailController.text.trim().isEmpty) {
                                    newErrors['email'] = 'Billing Email Address is a required field.';
                                    hasErrors = true;
                                  } else if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(emailController.text.trim())) {
                                    newErrors['email'] = 'Please enter a valid email address.';
                                    hasErrors = true;
                                  }
                                  if (phoneController.text
                                      .trim()
                                      .isEmpty) {
                                    newErrors['phone'] =
                                    'Billing Phone is a required field.';
                                    hasErrors = true;
                                  }

                                  if (hasErrors) {
                                    setState(() =>
                                        _fieldErrors.addAll(newErrors));
                                    return;
                                  }

                                  await _handleOrder(preferences, context,
                                      cartController, orderController,
                                      isGuest: true);
                                } else {
                                  if (profileController.profileData !=
                                      null &&
                                      profileController.profileData[
                                      "billing"] !=
                                          null &&
                                      (profileController.profileData[
                                      "billing"]["phone"] ??
                                          '')
                                          .isNotEmpty &&
                                      (profileController.profileData[
                                      "billing"]["email"] ??
                                          '')
                                          .isNotEmpty &&
                                      (profileController.profileData[
                                      "billing"]
                                      ["first_name"] ??
                                          '')
                                          .isNotEmpty &&
                                      (profileController.profileData[
                                      "billing"]
                                      ["last_name"] ??
                                          '')
                                          .isNotEmpty &&
                                      (profileController.profileData[
                                      "billing"]["address_1"] ??
                                          '')
                                          .isNotEmpty) {
                                    await _handleOrder(
                                        preferences,
                                        context,
                                        cartController,
                                        orderController);
                                  } else {
                                    toastification.show(
                                      alignment: Alignment.bottomCenter,
                                      type: ToastificationType.error,
                                      context: context,
                                      title: Text(
                                        'Billing address missing',
                                        style: GoogleFonts.roboto(
                                            fontSize: 15),
                                      ),
                                      autoCloseDuration:
                                      const Duration(seconds: 4),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'place_order'.tr,
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : const Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: AppColors.appPrimaryColor),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCodBadge() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4.0)
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.appPrimaryColor),
          const SizedBox(width: 12),
          Text(
            'Pay with cash upon delivery',
            style:
            GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool isRequired = false,
    String? errorKey,
  }) {
    final hasError = errorKey != null && _fieldErrors[errorKey] != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: (_) {
            if (hasError) {
              setState(() => _fieldErrors.remove(errorKey));
            }
          },
          decoration: InputDecoration(
            labelText: isRequired ? '$label *' : label,
            labelStyle: GoogleFonts.roboto(
              color: hasError ? Colors.red : null,
            ),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: hasError ? Colors.red : const Color(0xffD7D7D7),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColors.appPrimaryColor,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              _fieldErrors[errorKey]!,
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.red),
            ),
          ),
      ],
    );
  }

  Future<void> _handleOrder(
      SharedPreferences preferences,
      BuildContext context,
      CartController cartController,
      OrderController orderController, {
        bool isGuest = false,
      }) async {
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

    final customerId =
    isGuest ? null : "${preferences.getInt("customerId")}";

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

    if (isGuest) {
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

    final shipping = {
      "first_name": billing["first_name"],
      "last_name": billing["last_name"],
      "address_1": billing["address_1"],
      "address_2": billing["address_2"],
      "city": billing["city"],
      "state": billing["state"],
      "postcode": billing["postcode"],
    };

    orderController
        .createOrder(
      paymentName: "Cash on Delivery",
      customerId: customerId,
      setPaid: false,
      lineItems: formatLineItems(cartController.cartItems),
      billing: billing,
      shipping: shipping,
    )
        .then((value) {
      if (value == 201) {
        cartController.clearCart();
        Get.offAll(() => OrderSuccessScreen(isGuest: isGuest));
      }
    });
  }

}