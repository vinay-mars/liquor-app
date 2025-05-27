import 'package:get/get.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/order_repo.dart';

class OrderController extends GetxController{

  final OrderRepo orderRepo;

  OrderController({required this.orderRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingDetails = false;
  bool get isLoadingDetails => _isLoadingDetails;

  bool _isLoadingCreate = false;
  bool get isLoadingCreate => _isLoadingCreate;

  dynamic orderData;
  dynamic orderDetailsData;

  Future<dynamic> createOrder(
      {
        dynamic paymentName,
        dynamic customerId,
        dynamic setPaid,
        dynamic billing,
        dynamic shipping,
        dynamic lineItems,
      }
      ) async {
    _isLoadingCreate = true;
    update();
    ApiResponse apiResponse = await orderRepo.createOrder(
      paymentName: paymentName,
      customerId: customerId,
      setPaid: setPaid,
      billing: billing,
      shipping: shipping,
      lineItems: lineItems
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 201) {
      _isLoadingCreate = false;
      update();
      if (apiResponse.response!.data != null) {
        orderData = apiResponse.response!.data!;
        update();
      }
      return apiResponse.response!.statusCode;
    } else {
      _isLoadingCreate = false;
      update();
    }
  }

  Future<dynamic> getOrderListData() async {

    _isLoading = true;
    update();
    ApiResponse apiResponse = await orderRepo.getOrderListData();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        orderData = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  Future<dynamic> getOrderDetails({dynamic id}) async {

    _isLoadingDetails = true;
    update();
    ApiResponse apiResponse = await orderRepo.getOrderDetails(id: id);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingDetails = false;
      update();
      if (apiResponse.response!.data != null) {
        orderDetailsData = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoadingDetails = false;
      update();
    }
  }


}