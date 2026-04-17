import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/order_controller.dart';
import '../utils/app_colors.dart';

class OrderDetailsScreen extends StatefulWidget {
  dynamic id;
  dynamic status;
  OrderDetailsScreen({super.key,this.id,this.status});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int activeStep = 0;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<OrderController>().getOrderDetails(id: widget.id);
    });
    setState(() {
      // Set the active step based on the status
      activeStep = widget.status;
    });
    super.initState();
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
                  icon: const Icon(Icons.arrow_back_ios_new_outlined,color: AppColors.appWhiteColor,size: 20,),
                  onPressed: (){
                    Get.back();
                  },
                ),
                title: Text('order_details'.tr,style: GoogleFonts.roboto(
                    color: AppColors.appWhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),),
              ),
              body:
              orderController.isLoadingDetails==false && orderController.orderDetailsData!=null?
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'order_status'.tr,style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                          ),
                          Text(
                            formatDateTime(orderController.orderDetailsData["date_created"]),style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4,),
                      Row(
                        children: [
                          Text("order_id".tr,style: GoogleFonts.roboto(
                              fontSize: 14,
                          ),),Text(" ${orderController.orderDetailsData["id"]}",style: GoogleFonts.roboto(
                              fontSize: 14,
                          ),),
                        ],
                      ),
                      const Divider(
                        color: AppColors.appDealWeekBorderColor
                      ),
                      SizedBox(
                        height: 100,
                        child: EasyStepper(
                          finishedStepBorderType: BorderType.normal,
                          finishedStepBorderColor: AppColors.appPrimaryColor,
                          enableStepTapping: false,
                          activeStep: activeStep,
                          stepRadius: 20,
                          activeStepTextColor: AppColors.appPrimaryColor,
                          finishedStepTextColor: Colors.grey,
                          internalPadding: 10,
                          lineStyle: const LineStyle(lineType: LineType.normal),
                          showLoadingAnimation: false,
                          showStepBorder: false,
                          steps: [
                            EasyStep(
                              customStep: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  child: activeStep >= 0
                                      ? Icon(Icons.check_circle, color: Colors.white)
                                      : Icon(Icons.circle, color: Colors.white),
                                  radius: 15,
                                  backgroundColor:
                                  activeStep >= 0 ? AppColors.appPrimaryColor : Colors.grey,
                                ),
                              ),
                              title: 'Pending',
                            ),
                            EasyStep(
                              customStep: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  child: activeStep >= 1
                                      ? Icon(Icons.check_circle, color: Colors.white)
                                      : Icon(Icons.circle, color: Colors.white),
                                  radius: 15,
                                  backgroundColor:
                                  activeStep >= 1 ? AppColors.appPrimaryColor : Colors.grey,
                                ),
                              ),
                              title: 'Processing',
                            ),
                            EasyStep(
                              customStep: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  child: activeStep >= 2
                                      ? Icon(Icons.check_circle, color: Colors.white)
                                      : Icon(Icons.circle, color: Colors.white),
                                  radius: 15,
                                  backgroundColor:
                                  activeStep >= 2 ? AppColors.appPrimaryColor : Colors.grey,
                                ),
                              ),
                              title: 'Completed',
                            ),
                            EasyStep(
                              customStep: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  child: activeStep >= 2
                                      ? Icon(Icons.check_circle, color: Colors.white)
                                      : Icon(Icons.circle, color: Colors.white),
                                  radius: 15,
                                  backgroundColor:
                                  activeStep >= 2 ? AppColors.appPrimaryColor : Colors.grey,
                                ),
                              ),
                              title: 'Delivered',
                            ),
                          ],
                          onStepReached: (index) {
                            setState(() {
                              activeStep = index;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text("items".tr,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          ),),
                          Text(" (${orderController.orderDetailsData["line_items"].length})",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          ),),
                        ],
                      ),
                      const Divider(
                          color: AppColors.appDealWeekBorderColor
                      ),

                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderController.orderDetailsData["line_items"].length,
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.appWhiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.appDealWeekBorderColor
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16,vertical: 16
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("name".tr,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w500
                                              ),),
                                          ),Expanded(
                                            flex: 5,
                                              child: Text(" ${orderController.orderDetailsData["line_items"][index]["name"]}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w500
                                              ),),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6,),
                                      Row(
                                        children: [
                                          Text("quantity".tr,
                                            style: GoogleFonts.roboto(
                                                fontSize: 16
                                            ),
                                          ), Text(" ${orderController.orderDetailsData["line_items"][index]["quantity"]}",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6
                                        ,),
                                      ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: orderController.orderDetailsData["line_items"][index]["meta_data"].length,
                                        itemBuilder: (context, mIndex) {
                                          // Get the key and remove "pa_" prefix if it exists
                                          String originalKey = orderController.orderDetailsData["line_items"][index]["meta_data"][mIndex]["key"];
                                          String formattedKey = originalKey.startsWith('pa_') ? originalKey.replaceFirst('pa_', '') : originalKey;

                                          // Get the value
                                          String value = orderController.orderDetailsData["line_items"][index]["meta_data"][mIndex]["value"];

                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              // Display key and value on the same line
                                              Text(
                                                '$formattedKey: ',
                                                style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(left: 4.0), // Space between key and value
                                                child: Text(
                                                  value + (mIndex < orderController.orderDetailsData["line_items"][index]["meta_data"].length - 1 ? ', ' : ''), // Add comma unless it's the last item
                                                  style: GoogleFonts.roboto(fontSize: 15, color: AppColors.appBlackColor), // Change the color here
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(height: 20),
                      Text("your_order".tr,style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,fontSize: 16
                      ),),
                      const Divider(
                          color: AppColors.appDealWeekBorderColor
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.appWhiteColor,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("total_amount".tr,style: GoogleFonts.roboto(
                                fontSize: 14,
                              ),),
                              Text("${box.read("currency")}${orderController.orderDetailsData["total"]}",style: GoogleFonts.roboto(
                                  fontSize: 14,
                                fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text("payment_method".tr,style:  GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),),
                      const Divider(
                          color: AppColors.appDealWeekBorderColor
                      ),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.appWhiteColor,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                          child: Text("${orderController.orderDetailsData["payment_method"]}",style: GoogleFonts.roboto(
                              fontSize: 15
                          ),),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text("billing_address".tr,style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),),

                       const Divider(
                           color: AppColors.appDealWeekBorderColor
                      ),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.appWhiteColor,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                          child: Text(
                            [
                              "${orderController.orderDetailsData["billing"]["first_name"]} ${orderController.orderDetailsData["billing"]["last_name"]}",
                              orderController.orderDetailsData["billing"]["email"],
                              orderController.orderDetailsData["billing"]["phone"],
                              orderController.orderDetailsData["billing"]["address_1"],
                              orderController.orderDetailsData["billing"]["city"],
                              orderController.orderDetailsData["billing"]["postcode"],
                            ].where((s) => s != null && s.toString().trim().isNotEmpty).join('\n'),
                            style: GoogleFonts.roboto(fontSize: 15),
                          ),),
                        ),


                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ):
              const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.appPrimaryColor,
                  ),
                ),
              )
          );
        }
    );
  }

  String formatDateTime(String apiDateTime) {
    DateTime dateTime = DateTime.parse(apiDateTime);
    final DateFormat formatter = DateFormat('d MMM, yyyy, h:mm a');
    return formatter.format(dateTime);
  }
}
