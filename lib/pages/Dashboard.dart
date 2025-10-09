import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:avatars/avatars.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    penjualan = List<Penjualan>.from(penjualanList);
    stok = List<Obat>.from(stokObatList);
    _loadSavedTheme();
    _loadLastLogin();
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
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("User"),
              accountEmail: Text(widget.email),
              currentAccountPicture: Avatar(
                name: "User",
                shape: AvatarShape.circle(50),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profil"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Menu Edit Profil dipilih")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Pengaturan"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Menu Pengaturan dipilih")),
                );
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text("Tema"),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Beri Rating Aplikasi:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 35,
                    unratedColor: Colors.grey.shade300,
                    itemBuilder: (context, index) {
                      return const Icon(Icons.star, color: Colors.amber);
                    },
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _lastLogin != null
                        ? "Waktu: $_lastLogin"
                        : "Belum pernah login",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                "Logout",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
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
