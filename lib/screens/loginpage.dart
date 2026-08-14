import 'package:flutter/material.dart';

class loginPageScreen extends StatefulWidget {
  const loginPageScreen({super.key});

  @override
  State<loginPageScreen> createState() => _loginPageScreenState();
}

class _loginPageScreenState extends State<loginPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5B2DB8), Color(0xFF7B4DCC), Color(0xFF9B7BE5)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 1200,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(137, 211, 211, 211),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/college2.jpg", height: 80),
                  const SizedBox(height: 20),
                  const Text(
                    "College Connect /n Student Login ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email or Username",
                      labelStyle: const TextStyle(fontSize: 15),
                      hintText: "xyz@gmail.com",
                      hintStyle: const TextStyle(fontSize: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Password Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      labelStyle: const TextStyle(fontSize: 15),
                      hintText: "1234abcd",
                      hintStyle: const TextStyle(fontSize: 15),
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5B2DB8),
                      ),
                      child: const Text(
                        "Login Here",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Signup",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5B2DB8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
