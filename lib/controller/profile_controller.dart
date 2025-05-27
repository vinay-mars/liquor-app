import 'package:get/get.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/profile_repo.dart';

class ProfileController extends GetxController{

  final ProfileRepo profileRepo;

  ProfileController({required this.profileRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;

  bool _isLoadingUpdate = false;
  bool get isLoadingUpdate => _isLoadingUpdate;

  bool _isLoadingUpdateShipping = false;
  bool get isLoadingUpdateShipping => _isLoadingUpdateShipping;

  dynamic profileData;
  dynamic response;

  Future<dynamic> getProfileData() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await profileRepo.getProfileData();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        profileData = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoading = false;
      update();
    }
  }

   updateProfileData({dynamic firstName, dynamic lastName, dynamic email, dynamic phone}) async {
     _isLoadingUpdate = true;
    update();
    ApiResponse apiResponse = await profileRepo.updateProfileData(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingUpdate = false;
      update();
      if (apiResponse.response!.data != null) {
        profileData = apiResponse.response!.data!;
        update();
      }
    } else {
      _isLoadingUpdate = false;
      update();
    }
  }

   updateShippingAddress({
     dynamic firstName,
     dynamic lastName,
     dynamic address1,
     dynamic address2,
     dynamic city,
     dynamic postCode,
     dynamic state,
     dynamic phone,
   }) async {
     _isLoadingUpdateShipping = true;
    update();
    ApiResponse apiResponse = await profileRepo.updateShippingAddress(
        firstName: firstName,
        lastName: lastName,
        address1: address1,
        address2: address2,
        city: city,
        postCode: postCode,
        state: state,
        phone: phone
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingUpdateShipping = false;

      Get.back();
      update();
      if (apiResponse.response!.data != null) {
        getProfileData();
        update();
      }
      return apiResponse.response!.statusCode;
    } else {
      _isLoadingUpdateShipping = false;
      update();
    }
  }

  Future<dynamic> deleteUser() async {
    _isLoadingDelete = true;
    update();
    ApiResponse apiResponse = await profileRepo.deleteUser();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingDelete = false;
      update();
      if (apiResponse.response!.data != null) {
        response = apiResponse.response!.data!;
        print("sent>> ${response}");
        print("sent>> ${response}");
        print("sent>> ${response}");
        print("sent>> ${response}");
        print("sent>> ${response}");
        update();
      }
    } else {
      _isLoadingDelete = false;
      update();
    }
  }

}