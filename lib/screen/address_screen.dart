import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/profile_controller.dart';
import '../utils/app_colors.dart';

class AddressScreen extends StatefulWidget {
  dynamic firstName;
  dynamic lastName;
  dynamic address1;
  dynamic address2;
  dynamic city;
  dynamic postcode;
  dynamic state;
  dynamic phone;
  AddressScreen({super.key,this.state,this.postcode,this.city,this.address2,this.address1,this.lastName,this.firstName,this.phone});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProfileController>().getProfileData().then((value) {
        _firstNameController.text = profileController.profileData["billing"]["first_name"] ?? "";
        _lastNameController.text = profileController.profileData["billing"]["last_name"] ?? "";
        _address1Controller.text = profileController.profileData["billing"]["address_1"] ?? "";
        _address2Controller.text = profileController.profileData["billing"]["address_2"] ?? "";
        _cityController.text = profileController.profileData["billing"]["city"] ?? "";
        _postcodeController.text = profileController.profileData["billing"]["postcode"] ?? "";
        _stateController.text = profileController.profileData["billing"]["state"] ?? "";
        _phoneNumberController.text = profileController.profileData["billing"]["phone"] ?? "";

      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _stateController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
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
            title: Text('address_details'.tr,style: GoogleFonts.roboto(
                color: AppColors.appWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),),
          ),
          body:
          profileController.isLoading==false && profileController.profileData!=null?
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _firstNameController,
                            label: 'first_name'.tr,
                            hintText: 'enter_your_first_name'.tr,
                            isRequired: true,
                          ),
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _lastNameController,
                            label: 'last_name'.tr,
                            hintText: 'enter_last_name'.tr,
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildTextFormField(
                      controller: _phoneNumberController,
                      label: 'phone_number'.tr,
                      hintText: 'enter_your_phone_number'.tr,
                      isRequired: true,
                    ),

                    const SizedBox(height: 16),

                    _buildTextFormField(
                      controller: _address1Controller,
                      label: 'address_1'.tr,
                      hintText: 'enter_your_address'.tr,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _address2Controller,
                      label: 'address_2'.tr,
                      hintText: 'optional'.tr,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _cityController,
                      label: 'city'.tr,
                      hintText: 'enter_city'.tr,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _postcodeController,
                            label: 'postcodes'.tr,
                            hintText: 'enter_your_postcode'.tr,
                            isRequired: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _stateController,
                            label: 'state'.tr,
                            hintText: 'enter_your_state'.tr,
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),
                   

                    const SizedBox(height: 32),

                    Align(
                      alignment: Alignment.centerRight,
                      child:
                      profileController.isLoadingUpdateShipping==false?
                      MaterialButton(
                        color: AppColors.appPrimaryColor,
                        minWidth: double.infinity,
                        height: 50,
                        onPressed: () async{
                          if (_formKey.currentState?.validate() ?? false) {
                            // Handle save action
                            final firstName = _firstNameController.text;
                            final lastName = _lastNameController.text;
                            final address1 = _address1Controller.text;
                            final address2 = _address2Controller.text;
                            final city = _cityController.text;
                            final postcode = _postcodeController.text;
                            final state = _stateController.text;
                            final phoneNumber = _phoneNumberController.text;

                            // Perform your save action here, e.g., send data to a server or save locally
                            print('First Name: $firstName');
                            print('Last Name: $lastName');
                            print('Address 1: $address1');
                            print('Address 2: $address2');
                            print('City: $city');
                            print('Postcode: $postcode');
                            print('State: $state');
                            print('Phone Number: $phoneNumber');
                            //update
                            profileController.updateShippingAddress(
                              firstName: firstName,
                              lastName: lastName,
                              address1: address1,
                              address2: address2,
                              city: city,
                              postCode: postcode,
                              state: state,
                              phone: phoneNumber
                            ).then((value){
                              if(value==200){
                                print("data saved locally");
                                saveShippingDataLocally(
                                    firstName: firstName,
                                    lastName: lastName,
                                    address1: address1,
                                    address2: address2,
                                    city: city,
                                    postCode: postcode,
                                    state: state,
                                    phone: phoneNumber);
                                Navigator.pop(context);                              }
                            });

                          }
                        },
                        child: Text('save'.tr,style: GoogleFonts.roboto(
                          fontSize: 15,fontWeight: FontWeight.w500,
                          color: AppColors.appWhiteColor
                        ),),
                      ):
                          const Center(
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: AppColors.appPrimaryColor,
                              ),
                            ),
                          )
                    ),
                  ],
                ),
              ),
            ),
          ):
              const Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator()),
              )
        );
      }
    );
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

}

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.appTextFieldFillColor,
        labelText: label,
        hintText: hintText,
        hintStyle: GoogleFonts.roboto(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: AppColors.appTextFieldHintColor
        ),
        labelStyle: GoogleFonts.roboto(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Colors.black54
        ),
        border: InputBorder.none,
      ),

      validator: isRequired
          ? (value) {
        if (value == null || value.isEmpty) {
          return '$label required';
        }
        return null;
      }
          : null,
    );
  }
