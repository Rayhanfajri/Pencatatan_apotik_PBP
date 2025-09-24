import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    penjualan = List<Penjualan>.from(penjualanList);
    stok = List<Obat>.from(stokObatList);
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
          backgroundColor: Colors.teal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Text(
            titles[myIndex],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  "Selamat datang, ${widget.email}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      body: IndexedStack(index: myIndex, children: pages),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
            backgroundColor: Colors.white,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
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
