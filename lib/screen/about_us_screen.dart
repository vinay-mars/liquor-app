import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
        title:Text("About Us",style: GoogleFonts.roboto(
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
Welcome to Zilly!

At Zilly, we're passionate about transforming the way you shop online. Our mission is to provide you with an unparalleled shopping experience that combines convenience, variety, and innovation. Whether you're hunting for the latest fashion trends, top-notch electronics, or unique home essentials, Zilly is your go-to destination for discovering and buying products that fit your lifestyle.

Our Story

Zilly was born out of a vision to create a seamless and enjoyable shopping experience. We believe that shopping should be more than just a transaction—it should be an adventure. Our team is dedicated to curating a diverse range of high-quality products from trusted brands and sellers, all in one place. We strive to offer something for everyone, whether you're looking for everyday essentials or special treats.

What Sets Us Apart

Curated Collections: We handpick each item to ensure you have access to the best products on the market. Our curated collections are designed to make your shopping experience enjoyable and straightforward.

User-Friendly Interface: Our intuitive app interface makes it easy for you to browse, compare, and purchase products with just a few taps. We prioritize a smooth and hassle-free shopping journey from start to finish.

Customer-Centric Approach: Your satisfaction is our top priority. Our dedicated support team is here to assist you with any questions or concerns, ensuring a personalized and responsive shopping experience.

Secure Shopping: We use state-of-the-art security measures to protect your personal and payment information, so you can shop with confidence.

Join Us on This Journey

At Zilly, we're more than just an eCommerce platform—we're a community of enthusiastic shoppers and innovative thinkers. We invite you to explore our app, discover amazing products, and join us in redefining the future of online shopping.

Thank you for choosing Zilly. Happy shopping!

The Zilly Team
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
