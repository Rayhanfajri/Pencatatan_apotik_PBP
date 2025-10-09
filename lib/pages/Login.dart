import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dashboard.dart';
import 'regis.dart';
import '/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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

  Future<void> saveLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    await prefs.setString('last_login', now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Video
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
                            "Pencatatan Apotik",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _loginForm(),
                          const SizedBox(height: 30),
                          _emailInput("Email", "Masukkan Email", false),
                          const SizedBox(height: 30),
                          _passwordInput(),
                          _forgotPasswordBtn(context),
                          const SizedBox(height: 30),
                          _loginBtn(context),
                          const SizedBox(height: 30),
                          _daftarBtn(
                            context,
                            "Belum Punya Akun? Daftar",
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

  Widget _emailInput(String label, String hintText, bool isPassword) {
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

  Widget _loginBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
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

          User user;
          if (email.contains("admin")) {
            user = Admin(email, password);
          } else {
            user = Kasir(email, password);
          }

          user.login();

          await saveLastLogin();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(email: user.username),
            ),
          );
        },
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _daftarBtn(BuildContext context, String label, Color textColor) {
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
          fontSize: 14,
          color: textColor,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _forgotPasswordBtn(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          "Lupa Password?",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: SizedBox(child: Image.asset('assets/images/logo.png', height: 80)),
    );
  }

  Widget _loginForm() {
    return const Center(
      child: Text(
        "Login",
        style: TextStyle(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
