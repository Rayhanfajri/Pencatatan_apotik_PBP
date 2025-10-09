import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'login.dart';
import '/model/user.dart';

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
                constraints: const BoxConstraints(maxWidth: 600),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.white.withOpacity(0.25),
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 30),
                          _logo(),
                          const SizedBox(height: 10),
                          const Text(
                            "Registrasi Akun",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _regisForm(),
                          const SizedBox(height: 30),
                          _emailInput("Email", "Masukkan Email"),
                          const SizedBox(height: 30),
                          _passwordInput(),
                          const SizedBox(height: 30),
                          _confirmPasswordInput(),
                          const SizedBox(height: 30),
                          _regisBtn(context),
                          const SizedBox(height: 30),
                          _loginBtn(
                            context,
                            "Sudah punya akun? Login",
                            Colors.white,
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

  Widget _emailInput(String label, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
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

  Widget _passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(
            fontSize: 18,
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

  Widget _confirmPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Konfirmasi Password",
          style: TextStyle(
            fontSize: 18,
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

  Widget _regisBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();
          String confirmPassword = _confirmPasswordController.text.trim();

          if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Semua field harus diisi!"),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password dan konfirmasi tidak cocok!"),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          User user;
          if (email.contains("admin")) {
            user = Admin(email, password);
          } else {
            user = Kasir(email, password);
          }

          user.regis();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registrasi berhasil! Silakan login."),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        },
        child: const Text(
          'Daftar',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _loginBtn(BuildContext context, String label, Color textColor) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: SizedBox(child: Image.asset('assets/images/logo.png', height: 80)),
    );
  }

  Widget _regisForm() {
    return const Center(
      child: Text(
        "Buat Akun Baru",
        style: TextStyle(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
