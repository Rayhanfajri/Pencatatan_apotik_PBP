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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double basePadding = screenWidth < 600 ? 12 : 16;
    double bannerHeight = screenWidth < 600 ? 140 : 180;
    double titleFontSize = screenWidth < 600 ? 16 : 20;
    double valueFontSize = screenWidth < 600 ? 20 : 24;
    double iconSize = screenWidth < 600 ? 26 : 32;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: bannerHeight,
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
                child: Center(
                  child: Text(
                    "Aplikasi Pencatatan Apotik",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(basePadding),
              child: Column(
                children: [
                  SizedBox(height: basePadding + 10),

                  _infoCard(
                    title: "Total Penjualan",
                    value: "${penjualan.length}",
                    icon: Icons.show_chart_rounded,
                    color: Colors.blueAccent,
                    onTap: () => onTabChange(1),
                    iconSize: iconSize,
                    valueFontSize: valueFontSize,
                  ),

                  SizedBox(height: basePadding),

                  _infoCard(
                    title: "Total Stok Obat",
                    value: "$totalStok",
                    icon: Icons.local_pharmacy_rounded,
                    color: Colors.teal,
                    onTap: () => onTabChange(2),
                    iconSize: iconSize,
                    valueFontSize: valueFontSize,
                  ),

                  SizedBox(height: basePadding + 10),

                  Text(
                    "Selamat datang, ${email.split('@')[0]}!",
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth < 600 ? 14 : 16,
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
    required double iconSize,
    required double valueFontSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Card(
            elevation: 6,
            shadowColor: color.withOpacity(0.3),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
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
                    child: Icon(icon, size: iconSize, color: color),
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
                            fontSize: constraints.maxWidth < 400 ? 14 : 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: valueFontSize,
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
          );
        },
      ),
    );
  }
}
