import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF202156),
                    Color(0xFF0D485D),
                    Color(0xFF08032C),
                  ],
                  stops: [0.0, 0.4, 1.1],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(),
          ],
        ),
      ),
    );
  }
}
