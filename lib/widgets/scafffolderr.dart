import 'package:firebase_authentication_app/constans/colors.dart';
import 'package:firebase_authentication_app/constans/style.dart';
import 'package:flutter/material.dart';

// Custom Scaffold Error Message Widget
class CoustomScaffoldMassege {
  final String massege;
  final Color? bgColor;
  final double? delay;
  final BuildContext context;

  CoustomScaffoldMassege({
    required this.massege,
    required this.context,
    this.bgColor,
    this.delay,
  });

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor ?? Colors.red,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              massege,
              style: AppStyle().samllText.copyWith(
                    color: AppColors().mainWhite,
                  ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text(
                "Undo",
                style: AppStyle().samllText.copyWith(
                      color: AppColors().mainWhite,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // auto back after some delay

  void doneMassege() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor ?? const Color.fromARGB(255, 3, 128, 96),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              massege,
              style: AppStyle().samllText.copyWith(
                    color: AppColors().mainWhite,
                  ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text(
                " Undo",
                style: AppStyle().samllText.copyWith(
                      color: AppColors().mainWhite,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
