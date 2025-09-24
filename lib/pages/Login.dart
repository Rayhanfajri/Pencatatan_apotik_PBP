import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'dashboard.dart';
import 'regis.dart';
//import 'home2.dart'
import '/model/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF30C963)),
        child: AnimatedBackground(
          behaviour: RandomParticleBehaviour(
            options: ParticleOptions(
              baseColor: Color(0xFFFDFEFF),
              spawnOpacity: 0.4,
              opacityChangeRate: 0.25,
              minOpacity: 0.1,
              maxOpacity: 0.6,
              particleCount: 40,
              spawnMinSpeed: 20.0,
              spawnMaxSpeed: 70.0,
              spawnMinRadius: 2.0,
              spawnMaxRadius: 6.0,
            ),
          ),
          vsync: this,
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(24),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
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
                          Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: "Masukkan Password",
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
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
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _emailController,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
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
        onPressed: () {
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

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(email: user.username),
              //builder: (context) => Home2(),
            ),
          );
        },
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
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
            color: Colors.black,
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
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
