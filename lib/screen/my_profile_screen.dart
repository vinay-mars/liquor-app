import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/auth_controller.dart';
import '../controller/profile_controller.dart';
import '../utils/app_colors.dart';
import 'bottom_navbar.dart';


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

  void _confirmDeleteAccount(ProfileController profileController) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Account', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(
          'This permanently deletes your account and profile details. This cannot be undone.',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: GoogleFonts.roboto()),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final deleted = await profileController.deleteUser();
              if (deleted) {
                Get.find<AuthController>().removeUserToken();
                final preferences = await SharedPreferences.getInstance();
                await preferences.remove("customerId");
                Get.offAll(() => BottomNavbar(selectedIndex: 0));
                Get.snackbar('Account Deleted', 'Your account has been deleted.',
                    snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white70);
              } else {
                Get.snackbar('Delete Failed', 'We could not delete your account. Please try again.',
                    snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withValues(alpha: 0.15));
              }
            },
            child: Text('Delete', style: GoogleFonts.roboto(color: Colors.red)),
          ),
        ],
      ),
    );
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
                      const SizedBox(height: 16),


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
                      const SizedBox(height: 16),

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

                      const SizedBox(height: 24),

                      // Required by App Store Review Guideline 5.1.1(v): accounts created in-app must be deletable in-app.
                      TextButton.icon(
                        onPressed: profileController.isLoadingDelete
                            ? null
                            : () => _confirmDeleteAccount(profileController),
                        icon: profileController.isLoadingDelete
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
                              )
                            : const Icon(Icons.delete_outline, color: Colors.red),
                        label: Text('Delete Account',style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.red
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
