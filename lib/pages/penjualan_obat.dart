import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '/model/penjualan.dart';
import '/model/obat.dart';

class PenjualanObat extends StatefulWidget {
  final List<Penjualan> penjualan;
  final Function(List<Penjualan>) onUpdate;

  const PenjualanObat({
    super.key,
    required this.penjualan,
    required this.onUpdate,
  });

  @override
  State<PenjualanObat> createState() => _PenjualanObatState();
}

class _PenjualanObatState extends State<PenjualanObat> {
  late List<Penjualan> _penjualan;
  late List<Penjualan> _filteredPenjualan;
  final DateFormat _formatter = DateFormat('dd MMM yyyy');
  final TextEditingController _searchController = TextEditingController();
  String _sortOrder = 'terbaru';

  @override
  void initState() {
    super.initState();
    _penjualan = List<Penjualan>.from(widget.penjualan);
    _filteredPenjualan = List<Penjualan>.from(_penjualan);
    _searchController.addListener(_applyFilter);
    _sortData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPenjualan = _penjualan
          .where((item) => item.namaObat.toLowerCase().contains(query))
          .toList();
      _sortData();
    });
  }

  void _sortData() {
    _filteredPenjualan.sort((a, b) {
      final dateA = DateTime.tryParse(a.tanggal) ?? DateTime(1900);
      final dateB = DateTime.tryParse(b.tanggal) ?? DateTime(1900);
      return _sortOrder == 'terbaru'
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return _formatter.format(date);
    } catch (_) {
      return dateString;
    }
  }

  String? _getFotoObat(String namaObat) {
    final obat = stokObatList.firstWhere(
      (o) => o.namaObat.toLowerCase() == namaObat.toLowerCase(),
      orElse: () => Obat('', '', '', '', '', 0, 0, ''),
    );
    return obat.foto.isNotEmpty ? obat.foto : null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 800) {
      crossAxisCount = 3;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    double titleFontSize = screenWidth < 600 ? 14 : 16;
    double jumlahFontSize = screenWidth < 600 ? 13 : 14;
    double tanggalFontSize = screenWidth < 600 ? 12 : 13;
    double iconSize = screenWidth < 600 ? 22 : 28;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade100, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // ==================== SEARCH & SORT ====================
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Cari nama obat...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _sortOrder,
                  borderRadius: BorderRadius.circular(12),
                  items: const [
                    DropdownMenuItem(value: 'terbaru', child: Text("Terbaru")),
                    DropdownMenuItem(value: 'terlama', child: Text("Terlama")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortOrder = value;
                        _sortData();
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // ==================== GRID PENJUALAN ====================
          Expanded(
            child: _filteredPenjualan.isEmpty
                ? const Center(child: Text("Data tidak ditemukan"))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _filteredPenjualan.length,
                    itemBuilder: (context, index) {
                      final item = _filteredPenjualan[index];
                      final fotoPath = _getFotoObat(item.namaObat);

                      return GestureDetector(
                        onTap: () =>
                            _showDetailBottomSheet(context, index, item),
                        child: GFCard(
                          color: Colors.white,
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.all(10),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              fotoPath != null && fotoPath.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        fotoPath,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.medication,
                                      color: Colors.teal,
                                      size: iconSize,
                                    ),
                              Text(
                                item.namaObat,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: titleFontSize,
                                  color: Colors.teal,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Jumlah: ${item.jumlahTerjual}",
                                style: TextStyle(fontSize: jumlahFontSize),
                              ),
                              Text(
                                _formatDate(item.tanggal),
                                style: TextStyle(
                                  fontSize: tanggalFontSize,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ==================== TOMBOL AKSI & GRAFIK ====================
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: GFButton(
                    color: Colors.teal,
                    shape: GFButtonShape.pills,
                    fullWidthButton: true,
                    icon: const Icon(Icons.add, color: Colors.white),
                    text: "Tambah Penjualan",
                    onPressed: () => _showAddDialog(context),
                  ),
                ),
                const SizedBox(width: 12),
                GFIconButton(
                  icon: const Icon(Icons.bar_chart, color: Colors.teal),
                  shape: GFIconButtonShape.circle,
                  color: Colors.white,
                  onPressed: () => _showChartDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Text(
            "Grafik Penjualan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),

          _buildChartPreview(),
        ],
      ),
    );
  }

  // ==================== CHART PREVIEW ====================
  Widget _buildChartPreview() {
    if (_penjualan.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("Belum ada data penjualan.")),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final Map<String, int> dataByDate = {};
    for (var p in _penjualan) {
      dataByDate[p.tanggal] = (dataByDate[p.tanggal] ?? 0) + p.jumlahTerjual;
    }

    final dates = dataByDate.keys.toList();
    final values = dataByDate.values.toList();

    double fontSize = screenWidth < 400 ? 8 : (screenWidth < 600 ? 9 : 10);
    double labelRotation = screenWidth < 400
        ? -0.7
        : (screenWidth < 600 ? -0.4 : 0);

    return SizedBox(
      height: screenWidth < 400 ? 160 : 180,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 4 : 12),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 28),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int idx = value.toInt();
                    if (idx >= 0 && idx < dates.length) {
                      return Transform.rotate(
                        angle: labelRotation,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _formatDate(dates[idx]),
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(
              dates.length,
              (i) => BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: values[i].toDouble(),
                    color: Colors.teal,
                    width: screenWidth < 400 ? 12 : 18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== DETAIL BOTTOM SHEET ====================
  void _showDetailBottomSheet(BuildContext context, int index, Penjualan item) {
    final fotoPath = _getFotoObat(item.namaObat);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            fotoPath != null && fotoPath.isNotEmpty
                ? GFAvatar(
                    backgroundImage: AssetImage(fotoPath),
                    shape: GFAvatarShape.circle,
                    size: 80,
                  )
                : const GFAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.medication, color: Colors.white),
                    size: 80,
                  ),
            const SizedBox(height: 10),
            Text(
              item.namaObat,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text("Kode: ${item.kodeObat}"),
            Text("Kategori: ${item.namaKategori}"),
            Text("Jumlah: ${item.jumlahTerjual}"),
            Text("Tanggal: ${_formatDate(item.tanggal)}"),
          ],
        ),
      ),
    );
  }

  // ==================== TAMBAH DATA ====================
  void _showAddDialog(BuildContext context) {
    final TextEditingController kodeCtrl = TextEditingController();
    final TextEditingController namaCtrl = TextEditingController();
    final TextEditingController kategoriCtrl = TextEditingController();
    final TextEditingController jumlahCtrl = TextEditingController();
    final TextEditingController tanggalCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Penjualan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: kodeCtrl,
              decoration: const InputDecoration(labelText: "Kode Obat"),
            ),
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: "Nama Obat"),
            ),
            TextField(
              controller: kategoriCtrl,
              decoration: const InputDecoration(labelText: "Kategori Obat"),
            ),
            TextField(
              controller: jumlahCtrl,
              decoration: const InputDecoration(labelText: "Jumlah Terjual"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: tanggalCtrl,
              decoration: const InputDecoration(
                labelText: "Tanggal (YYYY-MM-DD)",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _penjualan.add(
                  Penjualan(
                    kodeObat: kodeCtrl.text,
                    namaObat: namaCtrl.text,
                    namaKategori: kategoriCtrl.text,
                    jumlahTerjual: int.tryParse(jumlahCtrl.text) ?? 0,
                    tanggal: tanggalCtrl.text,
                  ),
                );
                _applyFilter();
              });
              widget.onUpdate(_penjualan);
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // ==================== GRAFIK DETAIL ====================
  void _showChartDialog(BuildContext context) {
    final Map<String, int> dataByDate = {};
    for (var p in _penjualan) {
      dataByDate[p.tanggal] = (dataByDate[p.tanggal] ?? 0) + p.jumlahTerjual;
    }

    final dates = dataByDate.keys.toList();
    final values = dataByDate.values.toList();

    final double screenWidth = MediaQuery.of(context).size.width;
    final double chartWidth = screenWidth * 0.9;
    final double chartHeight = screenWidth < 600 ? 250 : 300;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Grafik Penjualan",
          style: TextStyle(color: Colors.teal),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth + (dates.length > 6 ? 200 : 0),
            height: chartHeight,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 1, // biar muncul satu kali per titik data
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < dates.length) {
                          double fontSize = screenWidth < 400 ? 8 : 10;
                          double rotation = screenWidth < 400 ? -0.8 : -0.5;
                          return Transform.rotate(
                            angle: rotation,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _formatDate(dates[idx]),
                                style: TextStyle(fontSize: fontSize),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: [
                      for (int i = 0; i < values.length; i++)
                        FlSpot(i.toDouble(), values[i].toDouble()),
                    ],
                    color: Colors.teal,
                    barWidth: screenWidth < 400 ? 2 : 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
                minX: 0,
                maxX: (values.length - 1).toDouble(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
