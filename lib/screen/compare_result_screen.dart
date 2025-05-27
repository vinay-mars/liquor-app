import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/cart_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/controller/product_controller.dart';
import 'package:zilly_flutter_woocommerce_mobile_app/utils/app_colors.dart';

class CompareResultScreen extends StatefulWidget {
  const CompareResultScreen({super.key});

  @override
  State<CompareResultScreen> createState() => _CompareResultScreenState();
}

class _CompareResultScreenState extends State<CompareResultScreen> {
  @override
  void initState() {
    // Fetch data for both comparison products after the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var compareItems = Get.find<CartController>().compareItems;
      if (compareItems.length > 1) {
        Get.find<ProductController>().getComparisonData1(compareItems[0].product_id);
        Get.find<ProductController>().getComparisonData2(compareItems[1].product_id);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.appPrimaryColor,
            leading: IconButton(
              onPressed: (){
                Get.back();
              },
              icon: const Icon(Icons.arrow_back, color: AppColors.appWhiteColor),
            ),
            title: Text("Comparison Result".tr, style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.appWhiteColor,
            )),
          ),
          body: productController.isLoadingComparison1 == false &&
              productController.isLoadingComparison2 == false &&
              productController.productComparisonData1 != null &&
              productController.productComparisonData2 != null
              ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(
                  color: AppColors.appProductBorderColor,
                  width: 1,
                ),
                children: [
                  // Header row with product attributes
                  TableRow(
                    decoration: const BoxDecoration(
                      color: AppColors.appPrimaryColor,
                    ),
                    children: [
                      _buildTableHeaderCell("Attribute"),
                      _buildTableHeaderCell("Product 1"),
                      _buildTableHeaderCell("Product 2"),
                    ],
                  ),
                  // Comparison rows for different attributes
                  TableRow(
                    children: [
                      _buildTableCell("Image"),
                      _buildTableCellImage(productController.productComparisonData1["images"][0]["src"]),
                      _buildTableCellImage(productController.productComparisonData2["images"][0]["src"]),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell("SkU"),
                      _buildTableCell(productController.productComparisonData1["sku"]),
                      _buildTableCell(productController.productComparisonData2["sku"]),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell("Name"),
                      _buildTableCell(productController.productComparisonData1["name"]),
                      _buildTableCell(productController.productComparisonData2["name"]),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell("Price"),
                      _buildTableCell("\$${productController.productComparisonData1["price"]}"),
                      _buildTableCell("\$${productController.productComparisonData2["price"]}"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell("Rating"),
                      _buildTableCell("${productController.productComparisonData1["rating_count"]}⭐"),
                      _buildTableCell("${productController.productComparisonData2["rating_count"]}⭐"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell("Stock"),
                      _buildTableCell("${productController.productComparisonData1["stock_status"]}"),
                      _buildTableCell("${productController.productComparisonData2["stock_status"]}"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell("Availability"),
                      _buildTableCell(productController.productComparisonData1["stock_quantity"]!=null?
                      "${productController.productComparisonData1["stock_quantity"]}":"-"),
                      _buildTableCell(
                          productController.productComparisonData2["stock_quantity"]!=null?
                          "${productController.productComparisonData2["stock_quantity"]}":"-"),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell("Description"),
                      _buildTableCellHtml(productController.productComparisonData1["description"]),
                      _buildTableCellHtml(productController.productComparisonData2["description"]),
                    ],
                  ),
                  // Add more attributes as needed
                ],
              ),
            ),
          )
              : const Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                color: AppColors.appPrimaryColor,
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to create table cells
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: GoogleFonts.roboto(fontSize: 14)),
    );
  }

  Widget _buildTableCellHtml(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlWidget(
        '''
             $text                       
                        ''',
      )
    );
  }

  Widget _buildTableCellImage(dynamic image) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.network(image,
        height: 80,
        width: 80,
      ),
    );
  }

  // Helper method to create table header cells
  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.appWhiteColor),
      ),
    );
  }
}
