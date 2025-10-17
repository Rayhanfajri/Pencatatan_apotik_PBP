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

  String _username = '';
  String _email = '';

  final List<String> tipsSehat = [
    "Minum air putih minimal 8 gelas sehari.",
    "Konsumsi buah dan sayur secara rutin.",
    "Rajin berolahraga minimal 30 menit setiap hari.",
    "Tidur cukup 7-8 jam setiap malam.",
    "Hindari begadang dan stres berlebihan.",
    "Cuci tangan sebelum makan dan setelah beraktivitas.",
    "Batasi konsumsi gula, garam, dan lemak.",
    "Jaga kebersihan lingkungan sekitar.",
  ];

  @override
  void initState() {
    super.initState();
    penjualan = List<Penjualan>.from(penjualanList);
    stok = List<Obat>.from(stokObatList);
    _loadSavedTheme();
    _loadLastLogin();
    _loadUserData();
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

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
      _email = prefs.getString('email') ?? widget.email;
    });
  }

  void _showTipsSehat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "💪 Tips Hidup Sehat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tipsSehat
                .map(
                  (tip) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• "),
                        Expanded(
                          child: Text(
                            tip,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth >= 600 && screenWidth < 1024;
        final isDesktop = screenWidth >= 1024;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              isDesktop ? 80 : (isTablet ? 70 : 65),
            ),
            child: AppBar(
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  titles[myIndex],
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              centerTitle: true,
            ),
          ),
          drawer: SizedBox(
            width: isDesktop
                ? screenWidth * 0.25
                : isTablet
                ? screenWidth * 0.35
                : screenWidth * 0.7,
            child: Drawer(
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
                    Container(
                      margin: EdgeInsets.all(isDesktop ? 24 : 16),
                      padding: EdgeInsets.all(isDesktop ? 20 : 16),
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
                          Avatar(
                            name: _username,
                            shape: AvatarShape.circle(isDesktop ? 55 : 45),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _username,
                                  style: TextStyle(
                                    fontSize: isDesktop ? 20 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _email,
                                  style: TextStyle(
                                    fontSize: isDesktop ? 16 : 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.white70,
                    ),
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
                                    builder: (context) =>
                                        EditProfil(email: _email),
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
                            ListTile(
                              leading: const Icon(
                                Icons.health_and_safety,
                                color: Colors.deepPurple,
                              ),
                              title: const Text(
                                "Tips Hidup Sehat",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _showTipsSehat();
                              },
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
                                    itemSize: isDesktop ? 40 : 32,
                                    unratedColor: Colors.grey.shade300,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating;
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Rating: $rating"),
                                        ),
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
                            MaterialPageRoute(
                              builder: (context) => const login(),
                            ),
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
                iconSize: isDesktop ? 30 : 24,
                selectedFontSize: isDesktop ? 16 : 12,
                unselectedFontSize: isDesktop ? 14 : 10,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
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
      },
    );
  }
}
