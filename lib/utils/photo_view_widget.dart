import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pringles_fine_wine/utils/app_colors.dart';

class PhotoViewWidget extends StatelessWidget {
  dynamic imageUrl;
  PhotoViewWidget({super.key,this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(imageUrl),
          ),
          Positioned(
              top: 80,
              right: 20,
              child: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.cancel,color: AppColors.appWhiteColor,size: 28,),
          ))
        ],
      ),
    );
  }
}
