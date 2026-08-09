import 'package:flutter/material.dart';

class Container1 extends StatelessWidget {
  const Container1({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.green, Colors.yellow],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
