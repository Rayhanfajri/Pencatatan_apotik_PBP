import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dashboard.dart';
import 'regis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _videoController =
        VideoPlayerController.asset("assets/videos/background.mp4")
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _videoController,
                aspectRatio: _videoController.value.aspectRatio,
                autoPlay: true,
                looping: true,
                showControls: false,
              );
            });
          });
  }

  Future<void> saveLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    await prefs.setString('last_login', now);
  }

  Future<bool> _checkLogin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersData = prefs.getStringList('users') ?? [];

    for (var data in usersData) {
      final parts = data.split('|');
      if (parts.length == 2 && parts[0] == email && parts[1] == password) {
        return true;
      }
    }

    return false;
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          return Stack(
            children: [
              if (_chewieController != null &&
                  _videoController.value.isInitialized)
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: Chewie(controller: _chewieController!),
                    ),
                  ),
                )
              else
                Container(color: Colors.black),

              Container(color: Colors.black.withOpacity(0.6)),

              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: width < 600 ? 16 : 32,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.white.withOpacity(0.25),
                          padding: EdgeInsets.all((width * 0.05).clamp(16, 32)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: height * 0.02),
                              _logo(width),
                              SizedBox(height: height * 0.015),
                              Text(
                                "Pencatatan Apotik",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: (width * 0.06).clamp(18, 28),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: height * 0.04),
                              _loginForm(width),
                              SizedBox(height: height * 0.03),
                              _emailInput(
                                "Email",
                                "Masukkan Email",
                                false,
                                width,
                              ),
                              SizedBox(height: height * 0.03),
                              _passwordInput(width),
                              SizedBox(height: height * 0.03),
                              _loginBtn(context, width),
                              SizedBox(height: height * 0.03),
                              _daftarBtn(
                                context,
                                "Belum Punya Akun? Daftar",
                                Colors.white,
                                width,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _passwordInput(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: TextStyle(
            fontSize: (width * 0.045).clamp(14, 20),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Masukkan Password",
            hintStyle: const TextStyle(color: Colors.white),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _emailInput(
    String label,
    String hintText,
    bool isPassword,
    double width,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: (width * 0.045).clamp(14, 20),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _emailController,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _loginBtn(BuildContext context, double width) {
    return SizedBox(
      width: double.infinity,
      height: (width * 0.12).clamp(45, 60),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () async {
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();

          if (email.isEmpty || password.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Email atau Password tidak boleh kosong!"),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          bool success = await _checkLogin(email, password);

          if (success) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('logged_in_email', email);
            await saveLastLogin();

            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard(email: email)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Email atau Password salah atau belum terdaftar!",
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: (width * 0.045).clamp(14, 20),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _daftarBtn(
    BuildContext context,
    String label,
    Color textColor,
    double width,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Regis()),
        );
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: (width * 0.035).clamp(12, 16),
          color: textColor,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _logo(double width) {
    return Center(
      child: SizedBox(
        child: Image.asset(
          'assets/images/logo.png',
          height: (width * 0.16).clamp(80, 120),
        ),
      ),
    );
  }

  Widget _loginForm(double width) {
    return Center(
      child: Text(
        "Login",
        style: TextStyle(
          fontSize: (width * 0.05).clamp(18, 26),
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
