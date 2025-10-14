import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfil extends StatefulWidget {
  final String email;
  const EditProfil({super.key, required this.email});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('username') ?? 'User';
    _emailController.text = prefs.getString('email') ?? widget.email;
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _nameController.text);
    await prefs.setString('email', _emailController.text);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profil berhasil diperbarui")));

    // 🔥 Kirim sinyal ke Dashboard bahwa data berubah
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
