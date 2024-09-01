import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coustom_flutter_widgets/input_feild.dart';
import 'package:coustom_flutter_widgets/page_animation.dart';
import 'package:firebase_authentication_app/authenticate/login.dart';
import 'package:firebase_authentication_app/constans/colors.dart';
import 'package:firebase_authentication_app/constans/style.dart';
import 'package:firebase_authentication_app/widgets/scafffolderr.dart';
import 'package:lottie/lottie.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController resetEmail = TextEditingController();

  bool isLoad = false;
  Timer? _timer;

  Future<void> clickSend() async {
    if (resetEmail.text.isEmpty) {
      CoustomScaffoldMassege(
        massege: "Enter email for send link",
        context: context,
      ).showError();
    } else {
      setState(() {
        isLoad = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: resetEmail.text,
        );

        _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(
            context,
            CoustomAnimation.pageAnimation(
              const LoginPage(),
              const Offset(1.0, 0.0),
              Offset.zero,
              Curves.easeInOut,
              500,
            ),
          );
          _timer?.cancel();
        });
        CoustomScaffoldMassege(
          massege: "Email send",
          // ignore: use_build_context_synchronously
          context: context,
        ).doneMassege();

        setState(() {
          isLoad = false;
        });
      } catch (e) {
        setState(() {
          isLoad = false;
        });
        CoustomScaffoldMassege(
          massege: "Check email again",
          // ignore: use_build_context_synchronously
          context: context,
        ).showError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors().appBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.password_rounded,
              size: 80,
            ),
            SizedBox(height: mHeight * 0.03),
            Text(
              "Enter your email and click the button. We will send a password reset link to the provided email. Please check your inbox and follow the instructions to reset your password.",
              style: AppStyle().samllText,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: mHeight * 0.05),
            CoustomInputWidget(
              controller: resetEmail,
              heigth: 17,
              backGroundColor: AppColors().mainWhite,
              borderColor: AppColors().mainWhite,
              hintText: "Email address",
            ),
            SizedBox(height: mHeight * 0.05),
            GestureDetector(
              onTap: () {
                isLoad ? null : clickSend();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors().mainBlack,
                ),
                width: double.infinity,
                height: 50,
                child: isLoad
                    ? Center(
                        child: Lottie.asset(
                          'assets/animation/loadingV4.json',
                          width: 50,
                          height: 50,
                        ),
                      )
                    : Center(
                        child: Text(
                          "Send email",
                          style: AppStyle()
                              .samllText
                              .copyWith(color: AppColors().mainWhite),
                        ),
                      ),
              ),
            ),
            SizedBox(height: mHeight * 0.05),
            SizedBox(height: mHeight * 0.05),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  CoustomAnimation.pageAnimation(
                    const LoginPage(),
                    const Offset(1.0, 0.0),
                    Offset.zero,
                    Curves.easeInOut,
                    500,
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: AppColors().mainBlue,
                    size: 15,
                  ),
                  Text(
                    "Back",
                    style: AppStyle().samllText.copyWith(
                          color: AppColors().mainBlue,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
