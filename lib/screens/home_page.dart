import 'package:coustom_flutter_widgets/page_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication_app/authenticate/login.dart';
import 'package:firebase_authentication_app/constans/style.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              "welcome",
              style: AppStyle().appTitle,
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(
                  // ignore: use_build_context_synchronously
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
              child: const Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
