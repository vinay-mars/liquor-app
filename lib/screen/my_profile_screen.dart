import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/profile_controller.dart';
import '../utils/app_colors.dart';


class MyProfileScreen extends StatefulWidget {
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  dynamic phone;
  MyProfileScreen({super.key,this.email,this.firstName,this.lastName,this.phone});

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _firstNameController.text = widget.firstName??"";
    _lastNameController.text = widget.lastName??"";
    _emailController.text = widget.email??"";
    _phoneController.text = widget.phone??"";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Scaffold(
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
            title: Text('Edit Profile',
              style: GoogleFonts.roboto(
                color: AppColors.appWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      TextFormField(
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.appTextFieldFillColor,
                          hintText: "Type first name",
                          hintStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: AppColors.appTextFieldHintColor
                          ),
                          border: InputBorder.none,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.appTextFieldFillColor,
                          hintText: "Type Last name",
                          hintStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: AppColors.appTextFieldHintColor
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(height: 16),


                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.appTextFieldFillColor,
                          hintText: "Type your email",
                          hintStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: AppColors.appTextFieldHintColor
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.appTextFieldFillColor,
                          hintText: "Type phone number",
                          hintStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: AppColors.appTextFieldHintColor
                          ),
                          border: InputBorder.none,
                        ),
                      ),


                      const SizedBox(height: 32),

                      MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        color: AppColors.appPrimaryColor,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            profileController.updateProfileData(
                              firstName: _firstNameController.text.toString(),
                              lastName: _lastNameController.text.toString(),
                              email: _emailController.text.toString(),
                              phone: _phoneController.text.toString(),
                            );
                          }
                        },
                        child: Text('Update Profile',style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: AppColors.appWhiteColor
                        ),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
