import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/screen/wishlist_screen.dart';
import '../controller/cart_controller.dart';
import '../utils/app_colors.dart';
import 'all_category_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'package:badges/badges.dart' as badges;

class BottomNavbar extends StatefulWidget {
  dynamic selectedIndex = 0;
  BottomNavbar({super.key,this.selectedIndex});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {


  final List<Widget> _screens = [
    const HomeScreen(),
    const AllCategoryScreen(),
    const WishListScreen(),
    CartScreen(),
  ];

  void _onItemTapped(int index) {
      setState(() {
        widget.selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return;
            }
            showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Dialog Content
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'exit'.tr,
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'sure_exit'.tr,
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black54, // Color for the Cancel button
                                    ),
                                    onPressed: () {
                                      Get.back(); // Do not exit
                                    },
                                    child: Text(
                                      'cancel'.tr,
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: AppColors.appWhiteColor
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.appPrimaryColor, // Primary color for the Exit button
                                    ),
                                    onPressed: () {
                                      SystemNavigator.pop(); // Exit the app
                                    },
                                    child: Text(
                                      'exit'.tr,
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: Colors.white, // Text color for the Exit button
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

          },

          child: Scaffold(
            body: _screens[widget.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedLabelStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 13
              ),
              selectedItemColor: AppColors.appPrimaryColor,
              unselectedItemColor: Colors.black54,
              type: BottomNavigationBarType.fixed,
              items:  <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset("assets/images/home_icon.png",height: 20,width: 20,
                  color: widget.selectedIndex==0?AppColors.appPrimaryColor:const Color(0xff959396),
                  ),
                  label: 'home'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset("assets/images/category_icon.png",height: 20,width: 20,
                    color: widget.selectedIndex==1?AppColors.appPrimaryColor:const Color(0xff959396),
                  ),
                  label: 'category'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset("assets/images/wish_list.png",height: 20,width: 20,
                    color: widget.selectedIndex==2?AppColors.appPrimaryColor:const Color(0xff959396),
                  ),
                  label: 'wishlist'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Obx(() => badges.Badge(
                    badgeContent: Text(cartController.cartItems.length.toString(),
                      style: GoogleFonts.roboto(color: Colors.white,fontSize: 15),),
                    child: Image.asset("assets/images/cart_icon.png",height: 20,width: 20,
                      color: widget.selectedIndex==3?AppColors.appPrimaryColor:const Color(0xff959396),
                    ),
                  )),
                  label: 'cart'.tr,
                ),

              ],
              currentIndex: widget.selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        );
      }
    );
  }
}
