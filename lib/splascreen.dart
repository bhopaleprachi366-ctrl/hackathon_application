import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
//import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   Timer(Duration(seconds: 2), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return LoginPage();
  //         },
  //       ),
  //     );
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF202156), Color(0xFF0D485D), Color(0xFF08032C)],
            stops: [0.0, 0.4, 1.1],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset(
                    'assets/animation/circleblue.json',
                    width: 200,
                    height: 200,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    height: 200,
                  ),
                ],
              ),

              Column(
                children: [
                  Text(
                    "EchoAI",
                    style: GoogleFonts.zenDots(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Speak. Command. Done.",
                    style: GoogleFonts.zenDots(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
