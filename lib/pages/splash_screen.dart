import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      MaterialPageRoute(builder: (context) => const login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        double scale(double size) {
          double baseScale = width / 400;
          if (baseScale > 1.5) baseScale = 1.5;
          if (baseScale < 0.7) baseScale = 0.7;
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
                Image.asset('assets/images/logo.png', height: scale(100)),
                SizedBox(height: scale(20)),

                Text(
                  "Pencatatan Apotik",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: scale(26),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: scale(25)),

                SpinKitWave(color: Colors.white, size: scale(50)),

                SizedBox(height: scale(25)),

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
