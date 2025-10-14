import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:avatars/avatars.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profil.dart';
import 'login.dart';
import 'home_page.dart';
import 'penjualan_obat.dart';
import 'stok_obat.dart';
import '/model/obat.dart';
import '/model/penjualan.dart';

class Dashboard extends StatefulWidget {
  final String email;

  const Dashboard({super.key, required this.email});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int myIndex = 0;
  final List<String> titles = ["Home", "Data Penjualan", "Cek Stok"];
  late List<Penjualan> penjualan;
  late List<Obat> stok;
  double _rating = 3.5;
  String? _lastLogin;

  // 🔹 Tambahan untuk data profil user
  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    penjualan = List<Penjualan>.from(penjualanList);
    stok = List<Obat>.from(stokObatList);
    _loadSavedTheme();
    _loadLastLogin();
    _loadUserData(); // 🟢 Load data user dari SharedPreferences
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('selectedTheme');
    if (savedTheme == 'light') {
      AdaptiveTheme.of(context).setLight();
    } else if (savedTheme == 'dark') {
      AdaptiveTheme.of(context).setDark();
    } else if (savedTheme == 'system') {
      AdaptiveTheme.of(context).setSystem();
    }
  }

  Future<void> _saveTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', themeMode);
  }

  Future<void> _loadLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastLogin = prefs.getString('last_login');
    });
  }

  // 🟢 Ambil nama dan email dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
      _email = prefs.getString('email') ?? widget.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        email: widget.email,
        penjualan: penjualan,
        stok: stok,
        onTabChange: (index) {
          setState(() {
            myIndex = index;
          });
        },
      ),
      PenjualanObat(
        penjualan: penjualan,
        onUpdate: (newData) {
          setState(() {
            penjualan = newData;
          });
        },
      ),
      StokObat(
        stok: stok,
        onUpdate: (newData) {
          setState(() {
            stok = newData;
          });
        },
      ),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Text(
            titles[myIndex],
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6A1B9A), Color(0xFFF3E5F5)],
            ),
          ),
          child: Column(
            children: [
              // HEADER PROFIL
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Avatar(name: _username, shape: AvatarShape.circle(45)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _username,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(thickness: 1, height: 1, color: Colors.white70),

              // MENU UTAMA
              Expanded(
                child: Container(
                  color: Colors.white.withOpacity(0.9),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.edit,
                          color: Colors.deepPurple,
                        ),
                        title: const Text(
                          "Edit Profil",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfil(email: _email),
                            ),
                          );
                          if (result == true) {
                            await _loadUserData();
                          }
                        },
                      ),
                      ExpansionTile(
                        leading: const Icon(
                          Icons.brightness_6,
                          color: Colors.deepPurple,
                        ),
                        title: const Text(
                          "Tema",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        children: [
                          ListTile(
                            title: const Text("Terang"),
                            onTap: () {
                              AdaptiveTheme.of(context).setLight();
                              _saveTheme('light');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text("Gelap"),
                            onTap: () {
                              AdaptiveTheme.of(context).setDark();
                              _saveTheme('dark');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text("Ikuti Sistem"),
                            onTap: () {
                              AdaptiveTheme.of(context).setSystem();
                              _saveTheme('system');
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Beri Rating Aplikasi:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RatingBar.builder(
                              initialRating: _rating,
                              minRating: 1,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 32,
                              unratedColor: Colors.grey.shade300,
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _rating = rating;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Rating: $rating")),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Terakhir Login:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _lastLogin != null
                                  ? "Waktu: $_lastLogin"
                                  : "Belum pernah login",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // LOGOUT BUTTON
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: IndexedStack(index: myIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).hintColor,
            currentIndex: myIndex,
            onTap: (index) {
              setState(() {
                myIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: "Penjualan",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: "Stok",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
