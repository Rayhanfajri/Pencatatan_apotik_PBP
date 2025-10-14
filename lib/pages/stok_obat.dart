import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '/model/obat.dart';
import '/model/kategoriobat.dart';

class StokObat extends StatefulWidget {
  final List<Obat> stok;
  final Function(List<Obat>) onUpdate;

  const StokObat({super.key, required this.stok, required this.onUpdate});

  @override
  State<StokObat> createState() => _StokObatState();
}

class _StokObatState extends State<StokObat> {
  late List<Obat> _stok;
  String selectedSort = "Harga Terendah";
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stok = List<Obat>.from(widget.stok);
  }

  List<Obat> get stok => _stok;

  set stok(List<Obat> newStok) {
    setState(() {
      _stok = newStok;
    });
    widget.onUpdate(_stok);
  }

  @override
  Widget build(BuildContext context) {
    List<Obat> filteredList = _stok
        .where(
          (obat) => obat.namaObat.toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
        )
        .toList();

    if (selectedSort == "Harga Terendah") {
      filteredList.sort((a, b) => a.harga.compareTo(b.harga));
    } else if (selectedSort == "Harga Tertinggi") {
      filteredList.sort((a, b) => b.harga.compareTo(a.harga));
    } else if (selectedSort == "Stok Terbanyak") {
      filteredList.sort((a, b) => b.stok.compareTo(a.stok));
    } else if (selectedSort == "Stok Tersedikit") {
      filteredList.sort((a, b) => a.stok.compareTo(b.stok));
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // 🔍 Search dan sorting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) => setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Cari nama obat...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedSort,
                  items: const [
                    DropdownMenuItem(
                      value: "Harga Terendah",
                      child: Text("Harga Terendah"),
                    ),
                    DropdownMenuItem(
                      value: "Harga Tertinggi",
                      child: Text("Harga Tertinggi"),
                    ),
                    DropdownMenuItem(
                      value: "Stok Terbanyak",
                      child: Text("Stok Terbanyak"),
                    ),
                    DropdownMenuItem(
                      value: "Stok Tersedikit",
                      child: Text("Stok Tersedikit"),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedSort = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // 🧱 Grid stok obat
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final obat = filteredList[index];
                return GestureDetector(
                  onTap: () => _showDetailBottomSheet(context, index, obat),
                  child: GFCard(
                    color: Colors.white,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.all(10),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GFAvatar(
                          backgroundImage: AssetImage(obat.foto),
                          shape: GFAvatarShape.circle,
                          size: 48,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          obat.namaObat,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.teal,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Rp ${obat.harga.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Stok: ${obat.stok}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ➕ Tombol tambah stok
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GFButton(
              onPressed: () => _showAddDialog(context),
              text: "Tambah Stok Obat",
              icon: const Icon(Icons.add, color: Colors.white),
              color: Colors.teal,
              size: GFSize.LARGE,
              shape: GFButtonShape.pills,
              blockButton: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailBottomSheet(BuildContext context, int index, Obat obat) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GFAvatar(
                backgroundImage: AssetImage(obat.foto),
                shape: GFAvatarShape.circle,
                size: 80,
              ),
              const SizedBox(height: 10),
              Text(
                obat.namaObat,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text("Kode: ${obat.kodeObat}"),
              Text("Kategori: ${obat.namaKategori}"),
              Text("Harga: Rp ${obat.harga.toStringAsFixed(0)}"),
              Text("Stok: ${obat.stok}"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GFButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditDialog(context, index, obat);
                    },
                    text: "Edit",
                    color: Colors.blue,
                    shape: GFButtonShape.pills,
                  ),
                  GFButton(
                    onPressed: () {
                      final updated = List<Obat>.from(_stok);
                      updated.removeAt(index);
                      stok = updated;
                      Navigator.pop(context);
                    },
                    text: "Hapus",
                    color: Colors.red,
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, Obat obat) {
    final namaController = TextEditingController(text: obat.namaObat);
    final stokController = TextEditingController(text: obat.stok.toString());
    final hargaController = TextEditingController(text: obat.harga.toString());

    // ✅ Amanin null value
    KategoriObat? selectedKategori = kategoriList.isNotEmpty
        ? kategoriList.firstWhere(
            (kat) => kat.idKategori == obat.idKategori,
            orElse: () => kategoriList.first,
          )
        : null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Edit Stok Obat"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Obat"),
              ),
              TextField(
                controller: stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah Stok"),
              ),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga"),
              ),
              DropdownButtonFormField<KategoriObat>(
                value: selectedKategori,
                decoration: const InputDecoration(labelText: "Kategori"),
                items: kategoriList.map((kat) {
                  return DropdownMenuItem(
                    value: kat,
                    child: Text(kat.namaKategori),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedKategori = value),
              ),
            ],
          ),
        ),
        actions: [
          GFButton(
            onPressed: () => Navigator.pop(context),
            text: "Batal",
            type: GFButtonType.outline,
            color: Colors.red,
          ),
          GFButton(
            onPressed: () {
              if (selectedKategori == null) return;
              final updated = List<Obat>.from(_stok);
              updated[index] = Obat(
                selectedKategori!.idKategori,
                selectedKategori!.namaKategori,
                selectedKategori!.deskripsi,
                obat.kodeObat,
                namaController.text,
                double.tryParse(hargaController.text) ?? obat.harga,
                int.tryParse(stokController.text) ?? obat.stok,
                obat.foto,
              );
              stok = updated;
              Navigator.pop(context);
            },
            text: "Simpan",
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final namaController = TextEditingController();
    final stokController = TextEditingController();
    final hargaController = TextEditingController();

    // ✅ Amanin kategoriList kosong
    KategoriObat? selectedKategori = kategoriList.isNotEmpty
        ? kategoriList.first
        : null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Tambah Stok Obat"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Obat"),
              ),
              TextField(
                controller: stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah Stok"),
              ),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga"),
              ),
              DropdownButtonFormField<KategoriObat>(
                value: selectedKategori,
                decoration: const InputDecoration(labelText: "Kategori"),
                items: kategoriList.map((kat) {
                  return DropdownMenuItem(
                    value: kat,
                    child: Text(kat.namaKategori),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedKategori = value),
              ),
            ],
          ),
        ),
        actions: [
          GFButton(
            onPressed: () => Navigator.pop(context),
            text: "Batal",
            type: GFButtonType.outline,
            color: Colors.red,
          ),
          GFButton(
            onPressed: () {
              if (namaController.text.isNotEmpty &&
                  stokController.text.isNotEmpty &&
                  hargaController.text.isNotEmpty &&
                  selectedKategori != null) {
                final updated = List<Obat>.from(_stok);
                updated.add(
                  Obat(
                    selectedKategori!.idKategori,
                    selectedKategori!.namaKategori,
                    selectedKategori!.deskripsi,
                    "OB${updated.length + 1}",
                    namaController.text,
                    double.tryParse(hargaController.text) ?? 0,
                    int.tryParse(stokController.text) ?? 0,
                    "assets/images/default.png",
                  ),
                );
                stok = updated;
                Navigator.pop(context);
              }
            },
            text: "Tambah",
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}
