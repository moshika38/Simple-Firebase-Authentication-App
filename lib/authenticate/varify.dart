import 'dart:async';

import 'package:coustom_flutter_widgets/page_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication_app/authenticate/login.dart';
import 'package:firebase_authentication_app/constans/colors.dart';
import 'package:firebase_authentication_app/constans/style.dart';
import 'package:firebase_authentication_app/screens/home_page.dart';
import 'package:firebase_authentication_app/widgets/scafffolderr.dart';
import 'package:flutter/material.dart';

class VarifyPage extends StatefulWidget {
  const VarifyPage({super.key});

  @override
  State<VarifyPage> createState() => _VarifyPageState();
}

class _VarifyPageState extends State<VarifyPage> {
  Timer? _timer;
  double refresh = 20;
  User? thisUser;

  void reSendEmail() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      thisUser = user;
      if (user != null) {
        try {
          await user.sendEmailVerification();
          CoustomScaffoldMassege(
            // ignore: use_build_context_synchronously
            context: context,
            massege: "Email send. check your inbox",
            bgColor: AppColors().textColor,
          ).showError();
        } catch (e) {
          CoustomScaffoldMassege(
            // ignore: use_build_context_synchronously
            context: context,
            massege: "Send faild ! Try again after 20 sec",
          ).showError();
        }
      }
    });
  }

  void clickButton() {
    // call re send function
    reSendEmail();

    // set 20 sec
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (refresh > 0) {
        setState(() {
          refresh--;
        });
      } else {
        setState(() {
          refresh = 20;
        });
        _timer?.cancel();
      }
    });
  }

  void checkVarify() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await thisUser?.reload();
      thisUser = FirebaseAuth.instance.currentUser;
      if (thisUser?.emailVerified ?? false) {
        _timer?.cancel();
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          CoustomAnimation.pageAnimation(
            const HomePage(),
            const Offset(1.0, 0.0),
            Offset.zero,
            Curves.easeInOut,
            500,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkVarify();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_user_sharp,
              size: 100,
            ),
            SizedBox(height: mHeight * 0.03),
            Text(
              "We've sent a verification email to your inbox. Please check your email and click the link to verify your account.",
              style: AppStyle().samllText.copyWith(height: 2, letterSpacing: 1),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: mHeight * 0.08),
            TextButton(
              onPressed: () {
                refresh == 20 ? clickButton() : null;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    refresh != 20 ? "($refresh)" : "",
                    style: AppStyle().samllText,
                  ),
                  Text(
                    " Re-Send",
                    style: AppStyle().samllText.copyWith(
                          color: refresh != 20
                              ? AppColors().textColor
                              : AppColors().mainBlack,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mHeight * 0.03),
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
