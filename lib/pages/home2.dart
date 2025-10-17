import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final String email;

  const Dashboard({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Ini Dashboard", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
