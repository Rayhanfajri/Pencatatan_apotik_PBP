import 'package:flutter/material.dart';
import '/model/obat.dart';
import '/model/penjualan.dart';

class HomePage extends StatelessWidget {
  final String email;
  final List<Penjualan> penjualan;
  final List<Obat> stok;
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
          colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)], // biru muda ke putih
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Tetap
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
                    color: Colors.black.withOpacity(0.25),
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
                child: const Center(
                  child: Text(
                    "Aplikasi Pencatatan Apotik",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  _infoCard(
                    title: "Total Penjualan",
                    value: "${penjualan.length}",
                    icon: Icons.show_chart_rounded,
                    color: Colors.blueAccent,
                    onTap: () => onTabChange(1),
                  ),

                  const SizedBox(height: 18),

                  _infoCard(
                    title: "Total Stok Obat",
                    value: "$totalStok",
                    icon: Icons.local_pharmacy_rounded,
                    color: Colors.teal,
                    onTap: () => onTabChange(2),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Selamat datang, ${email.split('@')[0]}!",
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shadowColor: color.withOpacity(0.3),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
