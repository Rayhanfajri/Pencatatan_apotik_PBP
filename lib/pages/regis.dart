import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Regis extends StatefulWidget {
  const Regis({super.key});

  @override
  State<Regis> createState() => _RegisState();
}

class _RegisState extends State<Regis> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Stack(
        children: [
          if (_chewieController != null && _videoController.value.isInitialized)
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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width < 500 ? width * 0.95 : 500,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.white.withOpacity(0.25),
                      padding: EdgeInsets.all((width * 0.06).clamp(16, 32)),
                      margin: EdgeInsets.all((width * 0.04).clamp(8, 24)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: height * 0.04),
                          _logo(width),
                          SizedBox(height: height * 0.01),
                          Text(
                            "Registrasi Akun",
                            style: TextStyle(
                              fontSize: (width * 0.06).clamp(18, 28),
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: height * 0.04),
                          _regisForm(width),
                          SizedBox(height: height * 0.04),
                          _emailInput("Email", "Masukkan Email", width),
                          SizedBox(height: height * 0.04),
                          _passwordInput(width),
                          SizedBox(height: height * 0.04),
                          _confirmPasswordInput(width),
                          SizedBox(height: height * 0.04),
                          _regisBtn(context, width),
                          SizedBox(height: height * 0.04),
                          _loginBtn(
                            context,
                            "Sudah punya akun? Login",
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
      ),
    );
  }

  Widget _emailInput(String label, String hintText, double width) {
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

  Widget _confirmPasswordInput(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Konfirmasi Password",
          style: TextStyle(
            fontSize: (width * 0.045).clamp(14, 20),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Masukkan Ulang Password",
            hintStyle: const TextStyle(color: Colors.white),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _regisBtn(BuildContext context, double width) {
    return SizedBox(
      width: double.infinity,
      height: (width * 0.12).clamp(45, 60),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () async {
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();
          final confirmPassword = _confirmPasswordController.text.trim();

          if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            _showSnack(context, "Semua field harus diisi!", Colors.red);
            return;
          }

          if (password != confirmPassword) {
            _showSnack(
              context,
              "Password dan konfirmasi tidak cocok!",
              Colors.red,
            );
            return;
          }

          try {
            final prefs = await SharedPreferences.getInstance();
            final usersData = prefs.getStringList('users') ?? [];

            bool emailExists = usersData.any((data) {
              final parts = data.split('|');
              return parts[0] == email;
            });

            if (emailExists) {
              _showSnack(context, "Email sudah terdaftar!", Colors.orange);
              return;
            }

            usersData.add('$email|$password');
            await prefs.setStringList('users', usersData);

            _showSnack(context, "Registrasi berhasil!", Colors.green);

            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const login()),
            );
          } catch (e) {
            debugPrint("❌ Error saat registrasi: $e");
            _showSnack(
              context,
              "Terjadi kesalahan saat registrasi.",
              Colors.red,
            );
          }
        },
        child: Text(
          "Daftar",
          style: TextStyle(
            fontSize: (width * 0.045).clamp(14, 20),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Widget _loginBtn(
    BuildContext context,
    String label,
    Color textColor,
    double width,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const login()),
        );
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: (width * 0.035).clamp(12, 18),
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
          height: (width * 0.16).clamp(60, 120),
        ),
      ),
    );
  }

  Widget _regisForm(double width) {
    return Center(
      child: Text(
        "Buat Akun Baru",
        style: TextStyle(
          fontSize: (width * 0.05).clamp(16, 24),
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
