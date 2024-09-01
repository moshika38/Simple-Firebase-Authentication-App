import 'package:firebase_authentication_app/constans/colors.dart';
import 'package:flutter/material.dart';

class AppStyle {
  final TextStyle appTitle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w800,
    color: Colors.black,
  );
  final TextStyle appSubTitle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  final TextStyle samllText = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    color: AppColors().textColor,
  );
}
