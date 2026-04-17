import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/product_category_controller.dart';
import '../utils/app_colors.dart';
import 'category_wise_product_screen.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductCategoryController>().getProductCategoryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductCategoryController>(
      builder: (productCategoryController) {
        return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            appBar: AppBar(
            backgroundColor: AppColors.appPrimaryColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text('all_categories'.tr,style: GoogleFonts.roboto(
              color: AppColors.appWhiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),),
          ),
          body:
          productCategoryController.isLoading
              ==false && productCategoryController.productCategoryData!=null?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of items per row
                crossAxisSpacing: 8.0, // Horizontal spacing between items
                mainAxisSpacing: 8.0, // Vertical spacing between items
                childAspectRatio: 1, // Aspect ratio of each item
              ),
              itemCount: productCategoryController.productCategoryData
                  .where((category) => category["name"].toString() != "Uncategorized")
                  .toList().length, // Use the filtered data list
              itemBuilder: (context, index) {

                final categoryData = productCategoryController.productCategoryData
                    .where((category) => category["name"].toString() != "Uncategorized")
                    .toList()[index];
                final name = categoryData["name"].toString();
                final imageSrc = categoryData["image"]?["src"];
                final id = categoryData["id"];
                final count = categoryData["count"]?.toString() ?? '0';

                return GestureDetector(
                  onTap: () {
                    Get.to(() => CategoryWiseProductScreen(
                      id: id,
                      name: name,
                    ));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      imageSrc.toString().endsWith("svg")
                          ? CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.appCategoryBgColor,
                          child: SvgPicture.network(imageSrc))
                          : imageSrc != null && imageSrc != false
                          ? CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.appCategoryBgColor,
                        child: ClipOval(
                          child: Image.network(
                            imageSrc,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.appCategoryBgColor,
                        child: Image.asset("assets/images/default_image.jpg"),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        name.replaceAll("&amp;", "&"),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            count,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              color: const Color(0xffA6A3A6),
                            ),
                          ),
                          Text(
                            "products".tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              color: const Color(0xffA6A3A6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
                :
        const Center(child: SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(color: AppColors.appPrimaryColor)))
        );
      },
    );
  }
}
