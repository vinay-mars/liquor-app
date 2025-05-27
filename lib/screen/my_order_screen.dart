import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/order_controller.dart';
import '../utils/app_colors.dart';
import 'bottom_navbar.dart';
import 'order_details_screen.dart';

class MyOrderScreen extends StatefulWidget {
  bool? orderPage;
  MyOrderScreen({super.key,this.orderPage});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<OrderController>().getOrderListData();
      _loadCustomerId();
    });
  }

  int? customerId; // Changed to int? to properly handle nullable types

  Future<void> _loadCustomerId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      customerId = preferences.getInt("customerId");
    });
    print("check Id >>> $customerId");
    // You might want to trigger a refresh if customerId is changed
    setState(() {});
  }

  final box = GetStorage(); // GetStorage instance

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        return Scaffold(
          backgroundColor: AppColors.appWhiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.appPrimaryColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined,size: 20,color: AppColors.appWhiteColor ,),
              onPressed: (){
                if(widget.orderPage==true){
                  Get.offAll(()=>  BottomNavbar(selectedIndex: 0,));
                }
                else{
                  Get.back();
                }
              },
            ),
            title: Text('my_orders'.tr,style: GoogleFonts.roboto(
                color: AppColors.appWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),),
          ),
          body: orderController.isLoading
              ? const Center(
            child: SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                color: AppColors.appPrimaryColor
              ),
            ),
          )
              : orderController.orderData != null
              ? ListView.builder(
            shrinkWrap: true,
            itemCount: orderController.orderData.length,
            itemBuilder: (context, index) {
              var order = orderController.orderData[index];
              // Ensure customerId is not null and match the integer type
              if (order["customer_id"].toString() == customerId.toString()) {
                return GestureDetector(
                  onTap: (){
                    Get.to(()=> OrderDetailsScreen(
                      id: order["id"],
                      status: checkStatusSend(orderController.orderData[index]["status"]),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF7F7F7),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'order_id'.tr,
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ), Text(
                                          ' ${order["id"]}',
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: checkStatus("${order["status"]}"),
                                        borderRadius: BorderRadius.circular(24)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,vertical: 5
                                        ),
                                        child: Text(
                                          '${order["status"]}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.appWhiteColor
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'total_item'.tr, // Replace with actual data
                                      style: GoogleFonts.roboto(fontSize: 14),
                                    ), Text(
                                      ' (${order["line_items"].length})', // Replace with actual data
                                      style: GoogleFonts.roboto(fontSize: 14),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'order_date'.tr, // Replace with actual data
                                      style: GoogleFonts.roboto(fontSize: 14),
                                    ), Text(
                                      ' ${formatDateTime(order["date_created"])}', // Replace with actual data
                                      style: GoogleFonts.roboto(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'shipping_addressed'.tr, // Replace with actual data
                                      style: GoogleFonts.roboto(fontSize: 14,color: const Color(0xff959396),fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${box.read("currency")}${order["total"]}', // Replace with actual data
                                      style: GoogleFonts.roboto(fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.appBlackColor
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  '${order["shipping"]["address_1"]} ${order["shipping"]["city"]} ${order["shipping"]["postcode"]} ', // Replace with actual data
                                  style: GoogleFonts.roboto(fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink(); // Return an empty widget if the condition is not met
              }
            },
          )
              : const SizedBox.shrink()
        );
      },
    );
  }

  checkStatus(dynamic status){
    if(status.toString() == "pending"){
      return const Color(0xffFFB636);
    }
    else if(status.toString() == "processing"){
      return const Color(0xff167A52);
    }
    else if(status.toString() == "completed"){
      return const Color(0xff167A52);
    }
    else if(status.toString() == "delivered"){
      return const Color(0xff167A52);
    }
    else {
      return const Color(0xffFF0029);
    }
  }

  String formatDateTime(String apiDateTime) {
    DateTime dateTime = DateTime.parse(apiDateTime);
    final DateFormat formatter = DateFormat('d MMM, yyyy, h:mm a');
    return formatter.format(dateTime);
  }

  checkStatusSend(dynamic status){
    if(status.toString().toLowerCase()=="pending"){
      return 0;
    }
    else if(status.toString().toLowerCase()=="processing"){
      return 1;
    }
    else if(status.toString().toLowerCase()=="completed"){
      return 2;
    }
    else if(status.toString().toLowerCase()=="delivered"){
      return 3;
    }
    else{
      return 0;
    }
  }
}
