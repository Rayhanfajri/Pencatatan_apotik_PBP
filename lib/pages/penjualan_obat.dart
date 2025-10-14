import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '/model/penjualan.dart';

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

  @override
  Widget build(BuildContext context) {
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
          // 🔹 SEARCH & SORT BAR
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

          // 🔹 GRID CARD
          Expanded(
            child: _filteredPenjualan.isEmpty
                ? const Center(child: Text("Data tidak ditemukan"))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: _filteredPenjualan.length,
                    itemBuilder: (context, index) {
                      final item = _filteredPenjualan[index];
                      return GestureDetector(
                        onTap: () => _showDetailDialog(context, item),
                        child: GFCard(
                          color: Colors.white,
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.all(10),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GFAvatar(
                                backgroundColor: Colors.teal.shade200,
                                child: const Icon(
                                  Icons.medication,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                shape: GFAvatarShape.circle,
                                size: 48,
                              ),
                              Text(
                                item.namaObat,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.teal,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Jumlah: ${item.jumlah}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Tanggal: ${_formatDate(item.tanggal)}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GFIconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    shape: GFIconButtonShape.circle,
                                    color: Colors.white,
                                    onPressed: () {
                                      final realIndex = _penjualan.indexOf(
                                        item,
                                      );
                                      _showEditDialog(context, realIndex, item);
                                    },
                                  ),
                                  GFIconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    shape: GFIconButtonShape.circle,
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _penjualan.remove(item);
                                        _applyFilter();
                                      });
                                      widget.onUpdate(_penjualan);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // 🔹 ADD & CHART BUTTON
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

  // 🔹 PREVIEW CHART KECIL
  Widget _buildChartPreview() {
    if (_penjualan.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("Belum ada data penjualan.")),
      );
    }

    final Map<String, int> dataByDate = {};
    for (var p in _penjualan) {
      dataByDate[p.tanggal] = (dataByDate[p.tanggal] ?? 0) + p.jumlah;
    }

    final dates = dataByDate.keys.toList();
    final values = dataByDate.values.toList();

    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _formatDate(dates[idx]),
                          style: const TextStyle(fontSize: 10),
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
                    width: 18,
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

  // 🔹 DIALOG DETAIL
  void _showDetailDialog(BuildContext context, Penjualan item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Detail Penjualan",
          style: TextStyle(color: Colors.teal),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Obat: ${item.namaObat}"),
            Text("Jumlah: ${item.jumlah}"),
            Text("Tanggal: ${_formatDate(item.tanggal)}"),
          ],
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

  // 🔹 DIALOG TAMBAH
  void _showAddDialog(BuildContext context) {
    final TextEditingController namaCtrl = TextEditingController();
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
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: "Nama Obat"),
            ),
            TextField(
              controller: jumlahCtrl,
              decoration: const InputDecoration(labelText: "Jumlah"),
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
                    namaObat: namaCtrl.text,
                    jumlah: int.tryParse(jumlahCtrl.text) ?? 0,
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

  // 🔹 DIALOG EDIT
  void _showEditDialog(BuildContext context, int index, Penjualan item) {
    final TextEditingController namaCtrl = TextEditingController(
      text: item.namaObat,
    );
    final TextEditingController jumlahCtrl = TextEditingController(
      text: item.jumlah.toString(),
    );
    final TextEditingController tanggalCtrl = TextEditingController(
      text: item.tanggal,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Penjualan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: "Nama Obat"),
            ),
            TextField(
              controller: jumlahCtrl,
              decoration: const InputDecoration(labelText: "Jumlah"),
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
                _penjualan[index] = Penjualan(
                  namaObat: namaCtrl.text,
                  jumlah: int.tryParse(jumlahCtrl.text) ?? 0,
                  tanggal: tanggalCtrl.text,
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

  // 🔹 DIALOG CHART BESAR
  void _showChartDialog(BuildContext context) {
    final Map<String, int> dataByDate = {};
    for (var p in _penjualan) {
      dataByDate[p.tanggal] = (dataByDate[p.tanggal] ?? 0) + p.jumlah;
    }

    final dates = dataByDate.keys.toList();
    final values = dataByDate.values.toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Grafik Penjualan",
          style: TextStyle(color: Colors.teal),
        ),
        content: SizedBox(
          width: 400,
          height: 300,
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
                    getTitlesWidget: (value, meta) {
                      int idx = value.toInt();
                      if (idx >= 0 && idx < dates.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _formatDate(dates[idx]),
                            style: const TextStyle(fontSize: 10),
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
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
