import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
            color: AppColors.appWhiteColor,size: 18,),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appPrimaryColor,
        title:Text("Privacy Policy",style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.appWhiteColor
        ),),
      ),

      body: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16,vertical: 8
            ),
            child: Column(
              children: [
                Text('''
Welcome to Zilly! Your privacy is important to us. This Privacy Policy outlines how we collect, use, disclose, and protect your personal information when you use our mobile application (the "App"). By using Zilly, you agree to the practices described in this policy.

1. Information We Collect

a. Personal Information: When you create an account, make a purchase, or interact with our App, we may collect personal information such as your name, email address, phone number, shipping address, and payment information.

b. Usage Data: We collect information about how you use our App, including your browsing history, search queries, and interactions with the App.

c. Device Information: We may collect information about your device, such as the device model, operating system, unique device identifiers, and IP address.

d. Cookies and Tracking Technologies: We use cookies and similar tracking technologies to enhance your experience, analyze usage, and provide personalized content.

2. How We Use Your Information

a. To Provide and Improve Our Services: We use your information to process transactions, manage your account, provide customer support, and improve our App.

b. To Personalize Your Experience: We may use your information to tailor our content and product recommendations to your preferences.

c. To Communicate With You: We may send you updates, promotional materials, and other communications related to our services. You can opt-out of marketing communications at any time.

d. To Ensure Security: We use your information to monitor and prevent fraud, enforce our terms of service, and protect the integrity of our App.

3. Sharing Your Information

a. Service Providers: We may share your information with third-party service providers who assist us in operating the App, processing payments, and delivering services. These providers are obligated to protect your information and use it only for the purposes for which we engaged them.

b. Legal Requirements: We may disclose your information if required to do so by law, or in response to valid requests by public authorities, such as a subpoena or court order.

c. Business Transfers: In the event of a merger, acquisition, or sale of assets, your information may be transferred to the new entity as part of the transaction.

4. Data Security

We implement reasonable security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no data transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.

5. Your Choices

a. Access and Update: You can access and update your personal information by logging into your account on the App.

b. Opt-Out: You can opt-out of receiving promotional communications from us by following the instructions in those communications or adjusting your preferences in the App.

c. Delete Account: You may request to delete your account and associated data by contacting our support team. Note that some information may be retained as required by law or for legitimate business purposes.

6. Children's Privacy

Our App is not intended for use by individuals under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete such information.

7. Changes to This Privacy Policy

We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the updated policy on the App and updating the effective date. We encourage you to review this Privacy Policy periodically.
              ''',
                  style: GoogleFonts.roboto(
                      fontSize: 15
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
