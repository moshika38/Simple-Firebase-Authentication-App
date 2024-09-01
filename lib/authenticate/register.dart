import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication_app/authenticate/varify.dart';
import 'package:coustom_flutter_widgets/page_animation.dart';
import 'package:firebase_authentication_app/authenticate/login.dart';
import 'package:firebase_authentication_app/constans/colors.dart';
import 'package:firebase_authentication_app/constans/images.dart';
import 'package:firebase_authentication_app/constans/style.dart';
import 'package:firebase_authentication_app/widgets/icons.dart';
import 'package:firebase_authentication_app/widgets/scafffolderr.dart';
import 'package:coustom_flutter_widgets/input_feild.dart';
import 'package:coustom_flutter_widgets/password_input.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conform = TextEditingController();

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    // mWidth in %
    final mWidth = MediaQuery.of(context).size.width;
    // mHeight in %
    final mHeight = MediaQuery.of(context).size.height;

    void register() async {
      if (email.text.isEmpty || password.text.isEmpty || conform.text.isEmpty) {
        CoustomScaffoldMassege(
          context: context,
          massege: "Please complete all fields",
        ).showError();
      } else {
        if (conform.text != password.text) {
          CoustomScaffoldMassege(
            context: context,
            massege: "Passwords do not match !",
          ).showError();
        } else {
          try {
            setState(() {
              isLoad = true;
            });
            final credential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email.text,
              password: password.text,
            );
            if (credential.user != null) {
              await credential.user?.sendEmailVerification();

              email.text = "";
              password.text = "";
              conform.text = "";
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                CoustomAnimation.pageAnimation(
                  const VarifyPage(),
                  const Offset(1.0, 0.0),
                  Offset.zero,
                  Curves.easeInOut,
                  500,
                ),
              );
            }
            setState(() {
              isLoad = false;
            });
          } on FirebaseAuthException catch (e) {
            setState(() {
              isLoad = false;
            });
            if (e.code == 'weak-password') {
              CoustomScaffoldMassege(
                // ignore: use_build_context_synchronously
                context: context,
                massege: "The password provided is too weak. !",
              ).showError();
            } else if (e.code == 'email-already-in-use') {
              CoustomScaffoldMassege(
                // ignore: use_build_context_synchronously
                context: context,
                massege: "The account already exists for that email.",
              ).showError();
            }
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors().appBgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: SizedBox(
            width: mWidth * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.app_registration_rounded,
                  size: 100,
                ),
                SizedBox(
                  height: mHeight * 0.1,
                  child: Center(
                    child: Text(
                      "Sing up",
                      style: AppStyle().appTitle,
                    ),
                  ),
                ),
                CoustomInputWidget(
                  controller: email,
                  heigth: 17,
                  suffixIcon: Icons.person,
                  borderColor: AppColors().appBgColor,
                  hintText: "Email",
                ),
                SizedBox(height: mHeight * 0.03),
                CoustomPasswordInput(
                  controller: password,
                  borderColor: AppColors().appBgColor,
                  heigth: 17,
                  hintText: "Password",
                ),
                SizedBox(height: mHeight * 0.03),
                CoustomPasswordInput(
                  controller: conform,
                  borderColor: AppColors().appBgColor,
                  heigth: 17,
                  hintText: "Re-Enter",
                ),
                SizedBox(height: mHeight * 0.03),
                GestureDetector(
                  onTap: () {
                    isLoad ? null : register();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors().mainBlack,
                    ),
                    height: 50,
                    width: double.infinity,
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
                              "Register",
                              style: AppStyle().samllText.copyWith(
                                    color: AppColors().mainWhite,
                                  ),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: mHeight * 0.03),
                Text(
                  "OR",
                  style: AppStyle().samllText,
                ),
                SizedBox(height: mHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIcons(
                      imageUrl: AppIMage().googleImage,
                      width: 55,
                      height: 55,
                    ),
                    SizedBox(width: mWidth * 0.05),
                    SocialIcons(
                      imageUrl: AppIMage().facebookImage,
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                SizedBox(height: mHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Alredy have an accout ? ",
                      style: AppStyle().samllText,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
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
                      child: Text(
                        "Login",
                        style: AppStyle().samllText.copyWith(
                              color: AppColors().mainBlue,
                            ),
                      ),
                    ),
                  ],
                )
              ], // page end
            ),
          ),
        ),
      ),
    );
  }
}
