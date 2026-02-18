import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/profile_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/compared_screen.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/deals_offer_screen.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/privacy_screen.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';
import '../controller/auth_controller.dart';
import '../controller/cart_controller.dart';
import '../controller/product_category_controller.dart';
import '../controller/product_controller.dart';
import '../utils/local_widget.dart';
import 'about_us_screen.dart';
import 'category_wise_product_screen.dart';
import 'details_screen.dart';
import 'home_result_screen.dart';
import 'login_screen.dart';
import 'my_order_screen.dart';
import 'my_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more data when reached the bottom
      Get.find<ProductController>()
          .getProductData(page: Get.find<ProductController>().currentPage + 1);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategory();
      _loadProduct();
      _scrollController.addListener(_scrollListener);
      Get.find<ProfileController>().getProfileData();
    });
    super.initState();
  }

  _loadCategory() async {
    await Get.find<ProductCategoryController>().getProductCategoryData();
  }

  _loadProduct() async {
    await Get.find<ProductController>().getProductData();
  }

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String? selectedCategoryName;
  dynamic selectedCategoryId;

  final box = GetStorage(); // GetStorage instance

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return GetBuilder<ProductCategoryController>(
          builder: (productCategoryController) {
        return GetBuilder<ProductController>(
          builder: (productController) {
            return RefreshIndicator(
              onRefresh: () async {
                _loadCategory();
                _loadProduct();
              },
              child: Scaffold(
                drawer: Drawer(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: Container(
                    width: double.infinity,
                  ),
                ),
                appBar: AppBar(
                  toolbarHeight: 130,
                  backgroundColor: AppColors.appWhiteColor,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Column(
                    children: [
                      GetBuilder<ProfileController>(
                          builder: (profileController) {
                        return Row(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                    onPressed: () {
                                      showGeneralDialog(
                                        context: context,
                                        barrierColor: Colors.black12
                                            .withOpacity(
                                                0.6), // Background color
                                        barrierDismissible: false,
                                        barrierLabel: 'Dialog',
                                        transitionDuration:
                                            const Duration(milliseconds: 400),
                                        pageBuilder: (context, __, ___) {
                                          return Material(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color:
                                                      AppColors.appWhiteColor),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 120,
                                                    width: double.infinity,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: AppColors
                                                                .appWhiteColor),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 32,
                                                              left: 32,
                                                              right: 16),
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                Get.back();
                                                              },
                                                              child: const Icon(
                                                                Icons.cancel,
                                                                color: AppColors
                                                                    .appBlackColor,
                                                              )),
                                                          const Expanded(
                                                              flex: 2,
                                                              child:
                                                                  SizedBox()),
                                                          Center(
                                                              child: SvgPicture
                                                                  .asset(
                                                            "assets/images/mars_logo.svg",
                                                            height: 30,
                                                            width: 80,
                                                          )),
                                                          const Expanded(
                                                              flex: 3,
                                                              child:
                                                                  SizedBox()),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  if (Get.find<AuthController>()
                                                      .getAuthToken()
                                                      .isNotEmpty) ...{
                                                    profileController
                                                                    .isLoading ==
                                                                false &&
                                                            profileController
                                                                    .profileData !=
                                                                null
                                                        ? Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        32,
                                                                    vertical:
                                                                        16),
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                      radius:
                                                                          30,
                                                                      backgroundColor: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.7),
                                                                      child: const Icon(
                                                                          Icons
                                                                              .person,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              40),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            12),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "${profileController.profileData["username"]}",
                                                                          style: GoogleFonts.roboto(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          "${profileController.profileData["email"]}",
                                                                          style:
                                                                              GoogleFonts.roboto(),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        6),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Color(0xffF7F7F7)),
                                                                      child:
                                                                          ListTile(
                                                                        onTap:
                                                                            () {
                                                                          Get.to(() =>
                                                                              MyProfileScreen(
                                                                                firstName: profileController.profileData["first_name"],
                                                                                lastName: profileController.profileData["last_name"],
                                                                                email: profileController.profileData["email"],
                                                                                phone: profileController.profileData["billing"]["phone"],
                                                                              ));
                                                                        },
                                                                        title:
                                                                            Text(
                                                                          "my_profile"
                                                                              .tr,
                                                                          style: GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14),
                                                                        ),
                                                                        leading:
                                                                            const Icon(
                                                                          Icons
                                                                              .person_2,
                                                                          color:
                                                                              AppColors.appPrimaryColor,
                                                                        ),
                                                                        trailing:
                                                                            const Icon(
                                                                          Icons
                                                                              .arrow_forward_ios_sharp,
                                                                          color:
                                                                              Color(0xff959396),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Color(0xffF7F7F7)),
                                                                      child:
                                                                          ListTile(
                                                                        onTap:
                                                                            () {
                                                                          Get.to(() =>
                                                                              MyOrderScreen());
                                                                        },
                                                                        title:
                                                                            Text(
                                                                          "my_order"
                                                                              .tr,
                                                                          style: GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14),
                                                                        ),
                                                                        leading:
                                                                            const Icon(
                                                                          Icons
                                                                              .sticky_note_2,
                                                                          color:
                                                                              AppColors.appPrimaryColor,
                                                                        ),
                                                                        trailing: const Icon(
                                                                            Icons
                                                                                .arrow_forward_ios_sharp,
                                                                            color:
                                                                                Color(0xff959396)),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            16,
                                                                      ),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Color(0xffF7F7F7)),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: const Icon(
                                                                                  Icons.language_outlined,
                                                                                  color: AppColors.appPrimaryColor,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 6,
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  "set_language".tr,
                                                                                  style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 14),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                ReusableLanguagePopupMenuButton(
                                                                                  widget: Text(
                                                                                    "lan_name".tr,
                                                                                    style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 14),
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  dropdownIconColor: Colors.black54,
                                                                                  dropdownIconSize: 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Color(0xffF7F7F7)),
                                                                      child:
                                                                          ListTile(
                                                                        onTap:
                                                                            () {
                                                                          Get.to(() =>
                                                                              const PrivacyScreen());
                                                                        },
                                                                        title:
                                                                            Text(
                                                                          "privacy_policy"
                                                                              .tr,
                                                                          style: GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14),
                                                                        ),
                                                                        leading:
                                                                            const Icon(
                                                                          Icons
                                                                              .privacy_tip_sharp,
                                                                          color:
                                                                              AppColors.appPrimaryColor,
                                                                        ),
                                                                        trailing: const Icon(
                                                                            Icons
                                                                                .arrow_forward_ios_sharp,
                                                                            color:
                                                                                Color(0xff959396)),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Color(0xffF7F7F7)),
                                                                      child:
                                                                          ListTile(
                                                                        onTap:
                                                                            () {
                                                                          Get.to(() =>
                                                                              const AboutUsScreen());
                                                                        },
                                                                        title:
                                                                            Text(
                                                                          "about_us"
                                                                              .tr,
                                                                          style: GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14),
                                                                        ),
                                                                        leading:
                                                                            const Icon(
                                                                          Icons
                                                                              .info,
                                                                          color:
                                                                              AppColors.appPrimaryColor,
                                                                        ),
                                                                        trailing: const Icon(
                                                                            Icons
                                                                                .arrow_forward_ios_sharp,
                                                                            color:
                                                                                Color(0xff959396)),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          24,
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              48,
                                                                          width:
                                                                              160,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                AppColors.appPrimaryColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                          ),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              showDialog(
                                                                                context: context,
                                                                                barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    titlePadding: const EdgeInsets.all(0), // Remove default padding
                                                                                    contentPadding: const EdgeInsets.all(0), // Remove default padding
                                                                                    actionsPadding: const EdgeInsets.all(0), // Remove default padding
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                                    ),
                                                                                    content: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                          child: Container(
                                                                                            color: AppColors.appPrimaryColor,
                                                                                            height: 2.0, // Thickness of the top line
                                                                                            width: double.infinity,
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          padding: const EdgeInsets.all(16.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Text(
                                                                                                'confirm_logout'.tr,
                                                                                                style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
                                                                                              ),
                                                                                              const SizedBox(height: 16.0),
                                                                                              Text(
                                                                                                'sure_logout'.tr,
                                                                                                style: GoogleFonts.roboto(),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    actions: <Widget>[
                                                                                      TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop(); // Close the dialog
                                                                                        },
                                                                                        child: Text(
                                                                                          'cancel'.tr,
                                                                                          style: GoogleFonts.roboto(color: Colors.red),
                                                                                        ),
                                                                                      ),
                                                                                      TextButton(
                                                                                        onPressed: () async {
                                                                                          setState(() {});
                                                                                          Get.find<AuthController>().removeUserToken();
                                                                                          await Get.to(() => LoginScreen(
                                                                                                selectedIndex: 0,
                                                                                              ));
                                                                                        },
                                                                                        child: Text('confirm'.tr),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                Center(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  const Icon(
                                                                                    Icons.logout,
                                                                                    color: AppColors.appWhiteColor,
                                                                                  ),
                                                                                  const SizedBox(width: 6),
                                                                                  Text(
                                                                                    "logout".tr,
                                                                                    style: GoogleFonts.roboto(
                                                                                      color: AppColors.appWhiteColor,
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : const Center(
                                                            child: SizedBox(
                                                                height: 22,
                                                                width: 22,
                                                                child: CircularProgressIndicator(
                                                                    color: AppColors
                                                                        .appPrimaryColor))),
                                                  } else ...{
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 16,
                                                                ),
                                                                decoration: const BoxDecoration(
                                                                    color: Color(
                                                                        0xffF7F7F7)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              const Icon(
                                                                            Icons.language_outlined,
                                                                            color:
                                                                                AppColors.appPrimaryColor,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              6,
                                                                        ),
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            "set_language".tr,
                                                                            style:
                                                                                GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          ReusableLanguagePopupMenuButton(
                                                                            widget:
                                                                                Text(
                                                                              "lan_name".tr,
                                                                              style: GoogleFonts.roboto(fontWeight: FontWeight.w500, fontSize: 14),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            dropdownIconColor:
                                                                                Colors.black54,
                                                                            dropdownIconSize:
                                                                                20,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              Container(
                                                                decoration: const BoxDecoration(
                                                                    color: Color(
                                                                        0xffF7F7F7)),
                                                                child: ListTile(
                                                                  onTap: () {
                                                                    Get.to(() =>
                                                                        const PrivacyScreen());
                                                                  },
                                                                  title: Text(
                                                                    "privacy_policy"
                                                                        .tr,
                                                                    style: GoogleFonts.roboto(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  leading:
                                                                      const Icon(
                                                                    Icons
                                                                        .privacy_tip_sharp,
                                                                    color: AppColors
                                                                        .appPrimaryColor,
                                                                  ),
                                                                  trailing: const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios_sharp,
                                                                      color: Color(
                                                                          0xff959396)),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              Container(
                                                                decoration: const BoxDecoration(
                                                                    color: Color(
                                                                        0xffF7F7F7)),
                                                                child: ListTile(
                                                                  onTap: () {
                                                                    Get.to(() =>
                                                                        const AboutUsScreen());
                                                                  },
                                                                  title: Text(
                                                                    "about_us"
                                                                        .tr,
                                                                    style: GoogleFonts.roboto(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  leading:
                                                                      const Icon(
                                                                    Icons.info,
                                                                    color: AppColors
                                                                        .appPrimaryColor,
                                                                  ),
                                                                  trailing: const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios_sharp,
                                                                      color: Color(
                                                                          0xff959396)),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 24,
                                                              ),
                                                              Center(
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child:
                                                                      Container(
                                                                    height: 48,
                                                                    width: 160,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppColors
                                                                          .appPrimaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                    ),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.to(() =>
                                                                            LoginScreen(
                                                                              selectedIndex: 0,
                                                                            ));
                                                                      },
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.login,
                                                                              color: AppColors.appWhiteColor,
                                                                            ),
                                                                            const SizedBox(width: 6),
                                                                            Text(
                                                                              "login".tr,
                                                                              style: GoogleFonts.roboto(
                                                                                color: AppColors.appWhiteColor,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  }
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.menu_outlined,
                                      color: AppColors.appBlackColor,
                                    ))),
                            const Expanded(flex: 4, child: SizedBox()),
                            Center(
                                child: SvgPicture.asset(
                              "assets/images/mars_logo.svg",
                              height: 35,
                              width: 90,
                            )),
                            const Expanded(flex: 6, child: SizedBox()),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const ComparedScreen());
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const Icon(
                                    Icons.cached,
                                    color: AppColors.appSecondaryColor,
                                    size: 26,
                                  ),
                                  Positioned(
                                      top: -10,
                                      left: 0,
                                      right: -8,
                                      child: CircleAvatar(
                                          backgroundColor:
                                              AppColors.appSecondaryColor,
                                          radius: 11,
                                          child: Text(
                                            "${cartController.compareItems.length}",
                                            textAlign: TextAlign.center,
                                          )))
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: TextFormField(
                                onFieldSubmitted: (value) {
                                  Get.to(() => HomeFilterScreen(
                                        search:
                                            _searchController.text.toString(),
                                        category: null,
                                      ))?.then((value) {
                                    _searchController.clear();
                                  });
                                },
                                textInputAction: TextInputAction.search,
                                controller: _searchController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.appWhiteColor,
                                  hintText: "what_are_looking_for".tr,
                                  hintStyle: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.appBlackColor)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.appBlackColor)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal:
                                            8), // Adjusted vertical padding
                                    child: Image.asset(
                                        "assets/images/search_icon.png",
                                        height: 20,
                                        width: 20),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal:
                                          12), // Reduced content padding
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: AppColors.appSecondaryColor,
                                ),
                                child: IconButton(
                                  icon: Image.asset(
                                      "assets/images/filter_icon.png",
                                      height: 24,
                                      width: 24),
                                  onPressed: () {
                                    Get.bottomSheet(
                                      Material(
                                          child: Container(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.6,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            16)),
                                              ),
                                              child: productCategoryController
                                                              .isLoading ==
                                                          false &&
                                                      productCategoryController
                                                              .productCategoryData !=
                                                          null
                                                  ? StatefulBuilder(builder:
                                                      (context, setState) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'filter'.tr,
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .cancel))
                                                              ],
                                                            ),
                                                          ),
                                                          const Divider(
                                                            color: Color(
                                                                0xffE9E7EA),
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: Text(
                                                              "category".tr,
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: 16,
                                                                  color: AppColors
                                                                      .appPrimaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Column(
                                                              children: <Widget>[
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black12), // Grey border
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5), // Rounded corners
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            16.0),
                                                                    child: DropdownButtonFormField<
                                                                        dynamic>(
                                                                      value:
                                                                          selectedCategoryName,
                                                                      hint:
                                                                          Text(
                                                                        'select_category'
                                                                            .tr,
                                                                        style: GoogleFonts
                                                                            .roboto(),
                                                                      ),
                                                                      onChanged:
                                                                          (dynamic
                                                                              newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedCategoryName =
                                                                              newValue;
                                                                          // Find the selected category ID based on the selected name
                                                                          final selectedCategory = productCategoryController.productCategoryData.firstWhere((category) =>
                                                                              category["name"] ==
                                                                              newValue);
                                                                          selectedCategoryId =
                                                                              selectedCategory["id"];

                                                                          // Print the selected category ID
                                                                          print(
                                                                              'Selected Category ID: $selectedCategoryId');
                                                                        });
                                                                      },
                                                                      items: productCategoryController
                                                                          .productCategoryData
                                                                          .map<DropdownMenuItem<String>>(
                                                                              (category) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              category["name"],
                                                                          child:
                                                                              Text(
                                                                            category["name"].toString().replaceAll("&amp;",
                                                                                ""),
                                                                            style:
                                                                                GoogleFonts.roboto(fontSize: 14),
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        border:
                                                                            InputBorder.none, // Remove the underline
                                                                        contentPadding:
                                                                            EdgeInsets.zero, // Remove padding inside the dropdown
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: Text(
                                                              "price_range".tr,
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: 16,
                                                                  color: AppColors
                                                                      .appPrimaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _minPriceController,
                                                                    keyboardType: const TextInputType
                                                                        .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'min_price'
                                                                              .tr,
                                                                      enabledBorder:
                                                                          const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                        color: AppColors
                                                                            .appProductBorderColor,
                                                                      )),
                                                                      focusedBorder:
                                                                          const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                        color: AppColors
                                                                            .appPrimaryColor,
                                                                      )),
                                                                      contentPadding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              8.0,
                                                                          horizontal:
                                                                              12.0), // Adjust vertical padding
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 16),
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _maxPriceController,
                                                                    keyboardType: const TextInputType
                                                                        .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'max_price'
                                                                              .tr,
                                                                      enabledBorder:
                                                                          const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                        color: AppColors
                                                                            .appProductBorderColor,
                                                                      )),
                                                                      focusedBorder:
                                                                          const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                        color: AppColors
                                                                            .appPrimaryColor,
                                                                      )),
                                                                      contentPadding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              8.0,
                                                                          horizontal:
                                                                              12.0), // Adjust vertical padding
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 24,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(color: AppColors.appProductBorderColor)),
                                                                    width: double
                                                                        .infinity,
                                                                    height: 50,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          selectedCategoryName =
                                                                              null;
                                                                          selectedCategoryId =
                                                                              null;
                                                                          _minPriceController
                                                                              .clear();
                                                                          _maxPriceController
                                                                              .clear();
                                                                        });
                                                                      },
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'reset'
                                                                              .tr,
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  child:
                                                                      MaterialButton(
                                                                    color: AppColors
                                                                        .appPrimaryColor,
                                                                    minWidth: double
                                                                        .infinity,
                                                                    height: 50,
                                                                    onPressed:
                                                                        () {
                                                                      Get.to(() =>
                                                                          HomeFilterScreen(
                                                                            category:
                                                                                selectedCategoryId,
                                                                            minPrice:
                                                                                _minPriceController.text.toString(),
                                                                            maxPrice:
                                                                                _maxPriceController.text.toString(),
                                                                          ));
                                                                    },
                                                                    child: Text(
                                                                      'apply'
                                                                          .tr,
                                                                      style: GoogleFonts.roboto(
                                                                          color: AppColors
                                                                              .appWhiteColor,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      );
                                                    })
                                                  : const Center(
                                                      child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColors
                                                              .appPrimaryColor,
                                                        ),
                                                      ),
                                                    ))),
                                      isScrollControlled:
                                          true, // Ensure that the bottom sheet can be scrolled
                                      ignoreSafeArea:
                                          false, // Depending on your design, you might need to adjust this
                                      backgroundColor: Colors
                                          .transparent, // Adjust as needed
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                body: productCategoryController.isLoading == false &&
                        productCategoryController.productCategoryData != null
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.to(() => const HomeFilterScreen());
                                },
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: 200,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1.0,
                                  ),
                                  items: [
                                    Image.asset(
                                      "assets/images/home_banner_new.jpg",
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Image.asset(
                                      "assets/images/home_banner_2.jpg",
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    // Add more images here if you like
                                  ],
                                )),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: productCategoryController
                                    .productCategoryData
                                    .where((category) =>
                                        category["name"].toString() !=
                                        "Uncategorized")
                                    .length,
                                itemBuilder: (context, index) {
                                  // Filtered categories list
                                  final filteredCategories =
                                      productCategoryController
                                          .productCategoryData
                                          .where((category) =>
                                              category["name"].toString() !=
                                              "Uncategorized")
                                          .toList();

                                  // Category data for the current index
                                  final category = filteredCategories[index];
                                  final imageUrl = category["image"]?["src"];
                                  final categoryName = category["name"]
                                          ?.replaceAll("&amp;", "&") ??
                                      "Unknown";


                                  return Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          log("Categoryyyyyyyyyyyyyyyyyyyyyyyyyy ${filteredCategories[index]}");
                                          // Get.to(
                                          //     () => CategoryWiseProductScreen(
                                          //           id: category["id"],
                                          //           name: categoryName,
                                          //         ));
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Display category image or default image
                                            imageUrl.toString().endsWith("svg")
                                                ? CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor: AppColors
                                                        .appCategoryBgColor,
                                                    child: SvgPicture.network(
                                                        imageUrl))
                                                : category["image"] != null &&
                                                        imageUrl != false
                                                    ? CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: AppColors
                                                            .appCategoryBgColor,
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            imageUrl,
                                                            width: 60,
                                                            height: 60,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    : ClipOval(
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor: AppColors
                                                              .appCategoryBgColor,
                                                          child: Image.asset(
                                                              "assets/images/default_image.jpg"),
                                                        ),
                                                      ),
                                            const SizedBox(height: 8),
                                            // Display category name
                                            Text(
                                              categoryName,
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            // Display category name
                                            Row(
                                              children: [
                                                Text(
                                                  "${category["count"]}",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 11,
                                                    color:
                                                        const Color(0xffA6A3A6),
                                                  ),
                                                ),
                                                Text(
                                                  "products".tr,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 11,
                                                    color:
                                                        const Color(0xffA6A3A6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "all_product".tr,
                                            style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() =>
                                                  const DealsOfferScreen());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        6), // Rounded corners
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors
                                                        .appPrimaryColor
                                                        .withOpacity(0.5),
                                                    offset: const Offset(-2, 2),
                                                    blurRadius: 0,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                child: Text(
                                                  "deals_offer".tr,
                                                  style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.4,
                                                    color: AppColors
                                                        .appPrimaryColor,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                color: AppColors.appProductBorderColor
                                    .withOpacity(0.85),
                              ),
                            ),
                            GetBuilder<CartController>(
                              builder: (cartController) {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(15),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 0.66,
                                  ),
                                  itemCount:
                                      productController.productData.length +
                                          (productController.isMoreDataAvailable
                                              ? 1
                                              : 0),
                                  itemBuilder: (_, index) {
                                    if (index >=
                                        productController.productData.length) {
                                      return const Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                      );
                                    }

                                    var product =
                                        productController.productData[index];
                                    var item = CartItem(
                                      product_id: product["id"].toString(),
                                      name: product["name"],
                                      image: product["images"].isNotEmpty
                                          ? product["images"][0]["src"]
                                          : null,
                                      price: product["price"],
                                    );

                                    // Check if the item is already in the wishlist
                                    bool isInWishlist = cartController
                                        .wishlistItems
                                        .any((existingItem) =>
                                            existingItem.product_id ==
                                            item.product_id);

                                    return Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => DetailsScreen(
                                                  id: "${product["id"]}",
                                                  name: "${product["name"]}",
                                                  relatedIds:
                                                      product["related_ids"],
                                                  image:
                                                      "${product["images"].isNotEmpty ? product["images"][0]["src"] : null}",
                                                  price: "${product["price"]}",
                                                  variationId: product[
                                                              "variations"]
                                                          .isNotEmpty
                                                      ? product["variations"][0]
                                                      : null,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors
                                                      .appProductBorderColor
                                                      .withOpacity(0.85)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    product["images"].isNotEmpty
                                                        ? Center(
                                                            child: Hero(
                                                              tag: item
                                                                  .product_id,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            16),
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    item.image,
                                                                    width: 110,
                                                                    height: 110,
                                                                    // fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 16),
                                                              child: ClipOval(
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/default_image.jpg",
                                                                  width: 110,
                                                                  height: 110,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              product["categories"]
                                                                      .isNotEmpty
                                                                  ? product["categories"]
                                                                              [
                                                                              0]
                                                                          [
                                                                          "name"]
                                                                      .toString()
                                                                      .replaceAll(
                                                                          "&amp;",
                                                                          "")
                                                                  : '',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                                color: const Color(
                                                                    0xff959396),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 6),
                                                            Text(
                                                              "${box.read("currency")}${item.price}",
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                                color: AppColors
                                                                    .appPrimaryColor,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 2),
                                                            Text(
                                                              item.name,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: const Color(
                                                                    0xff333333),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.star,
                                                                    color: AppColors
                                                                        .appSecondaryColor,
                                                                    size: 15),
                                                                Text(
                                                                  "${product["average_rating"] ?? 'N/A'} (${product["rating_count"] ?? '0'})",
                                                                  style: GoogleFonts
                                                                      .roboto(
                                                                          fontSize:
                                                                              13),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Positioned(
                                                    top: 8,
                                                    right: 10,
                                                    child: isInWishlist == false
                                                        ? Column(
                                                            children: [
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {});
                                                                    cartController
                                                                        .addToWishlist(
                                                                            item);
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .favorite_outline,
                                                                    color: AppColors
                                                                        .appBlackColor
                                                                        .withOpacity(
                                                                            0.50),
                                                                    size: 24,
                                                                  )),
                                                            ],
                                                          )
                                                        : Image.asset(
                                                            "assets/images/wishlist_already.png",
                                                            height: 24,
                                                            width: 24)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                color: AppColors.appPrimaryColor))),
              ),
            );
          },
        );
      });
    });
  }
}
