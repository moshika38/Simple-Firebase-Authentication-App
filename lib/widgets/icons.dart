import 'package:firebase_authentication_app/constans/colors.dart';

import 'package:flutter/material.dart';

class SocialIcons extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  const SocialIcons({super.key, required this.imageUrl, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors().mainWhite,
      ),
      width: 80,
      height: 80,
      child: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
