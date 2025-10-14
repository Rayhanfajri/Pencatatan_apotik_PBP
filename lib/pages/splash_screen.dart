import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // Batas maksimal skala agar tampilan tidak terlalu besar
        double scale(double size) {
          double baseScale = width / 400;
          if (baseScale > 1.5) baseScale = 1.5; // max scale
          if (baseScale < 0.7) baseScale = 0.7; // min scale
          return size * baseScale;
        }

        return Scaffold(
          body: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logo.png', height: scale(100)),
                SizedBox(height: scale(20)),

                // Judul
                Text(
                  "Pencatatan Apotik",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: scale(26),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: scale(15)),

                // Loading
                SizedBox(
                  width: scale(35),
                  height: scale(35),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),

                SizedBox(height: scale(15)),

                // Credit
                Text(
                  "by Rayhan Fajri A",
                  style: TextStyle(
                    fontSize: scale(14),
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
