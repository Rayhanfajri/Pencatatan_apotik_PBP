import 'package:flutter/material.dart';
import '/model/obat.dart';
import '/model/penjualan.dart';

class HomePage extends StatelessWidget {
  final String email;
  final List<Penjualan> penjualan; // dari model Penjualan
  final List<Obat> stok; // dari model Obat
  final Function(int) onTabChange;

  const HomePage({
    super.key,
    required this.email,
    required this.penjualan,
    required this.stok,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    int totalStok = stok.fold(0, (sum, item) => sum + item.stok);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                image: const DecorationImage(
                  image: AssetImage("assets/images/banner.png"),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Colors.black.withOpacity(0.25),
                ),
                child: Center(
                  child: Text(
                    "Aplikasi Pencatatan Apotik",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Info Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  _infoCard(
                    "Total Penjualan",
                    "${penjualan.length}", // jumlah transaksi
                    Icons.bar_chart,
                    Colors.blue,
                    () => onTabChange(1), // klik pindah ke tab penjualan
                  ),

                  const SizedBox(height: 16),

                  // info total stok obat
                  _infoCard(
                    "Total Stok Obat",
                    "$totalStok",
                    Icons.inventory,
                    Colors.green,
                    () => onTabChange(2), // klik pindah ke tab stok
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
