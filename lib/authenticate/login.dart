import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication_app/screens/home_page.dart';
import 'package:firebase_authentication_app/widgets/scafffolderr.dart';
import 'package:flutter/material.dart';
import 'package:coustom_flutter_widgets/page_animation.dart';
import 'package:firebase_authentication_app/authenticate/forgot.dart';
import 'package:firebase_authentication_app/authenticate/register.dart';
import 'package:firebase_authentication_app/constans/colors.dart';
import 'package:firebase_authentication_app/constans/images.dart';
import 'package:firebase_authentication_app/constans/style.dart';
import 'package:firebase_authentication_app/widgets/icons.dart';
import 'package:coustom_flutter_widgets/input_feild.dart';
import 'package:coustom_flutter_widgets/password_input.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    // mWidth in %
    final mWidth = MediaQuery.of(context).size.width;
    // mHeight in %
    final mHeight = MediaQuery.of(context).size.height;

    Future<void> loginUser() async {
      if (email.text.isEmpty || password.text.isEmpty) {
        CoustomScaffoldMassege(
          massege: "Please complete all fields",
          context: context,
        ).showError();
      } else {
        setState(() {
          isLoad = true;
        });
        try {
          final credential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );

          if (credential.user != null) {
            email.text = "";
            password.text = "";

            // locate to home page
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

          setState(() {
            isLoad = false;
          });
        } on FirebaseAuthException {
          setState(() {
            isLoad = false;
          });
          CoustomScaffoldMassege(
            massege: "Email or Password is invaleed !",
            // ignore: use_build_context_synchronously
            context: context,
          ).showError();
        }
      }
    }

    Future<UserCredential> signInWithFacebook() async {
      // Create a new provider
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
    }

    Future<UserCredential> signInWithGoogle() async {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
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
                  Icons.login,
                  size: 100,
                ),
                SizedBox(
                  height: mHeight * 0.1,
                  child: Center(
                    child: Text(
                      "Sing in",
                      style: AppStyle().appTitle,
                    ),
                  ),
                ),
                CoustomInputWidget(
                  controller: email,
                  heigth: 17,
                  hintText: "Email",
                  suffixIcon: Icons.person,
                  borderColor: AppColors().appBgColor,
                ),
                SizedBox(height: mHeight * 0.03),
                CoustomPasswordInput(
                  hintText: "Password",
                  controller: password,
                  borderColor: AppColors().appBgColor,
                  heigth: 17,
                ),
                SizedBox(height: mHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CoustomAnimation.pageAnimation(
                            const ForgotPassword(),
                            const Offset(-1.0, 0.0),
                            Offset.zero,
                            Curves.easeInOut,
                            500,
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password ?",
                        style: AppStyle().samllText,
                      ),
                    )
                  ],
                ),
                SizedBox(height: mHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    isLoad ? null : loginUser();
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
                            "Log in",
                            style: AppStyle()
                                .samllText
                                .copyWith(color: AppColors().mainWhite),
                          )),
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
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: SocialIcons(
                        imageUrl: AppIMage().googleImage,
                        width: 55,
                        height: 55,
                      ),
                    ),
                    SizedBox(width: mWidth * 0.05),
                    GestureDetector(
                      onTap: () {
                        signInWithFacebook();
                      },
                      child: SocialIcons(
                        imageUrl: AppIMage().facebookImage,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont have an accout ? ",
                      style: AppStyle().samllText,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CoustomAnimation.pageAnimation(
                            const RegisterPage(),
                            const Offset(-1.0, 0.0),
                            Offset.zero,
                            Curves.easeInOut,
                            500,
                          ),
                        );
                      },
                      child: Text(
                        "Register",
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
