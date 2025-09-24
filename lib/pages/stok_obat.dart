import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade100, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _stok.length,
                  itemBuilder: (context, index) {
                    final obat = _stok[index];
                    return Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(obat.foto),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.medication),
                        ),
                        title: Text(
                          obat.namaObat,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        subtitle: Text(
                          "Kategori: ${obat.namaKategori}\nStok: ${obat.stok}\nHarga: Rp ${obat.harga}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(
                                obat.namaObat,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: AssetImage(obat.foto),
                                      onBackgroundImageError: (_, __) =>
                                          const Icon(Icons.medication),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text("Kode Obat   : ${obat.kodeObat}"),
                                  Text("Kategori    : ${obat.namaKategori}"),
                                  Text("Deskripsi   : ${obat.deskripsi}"),
                                  Text("Harga       : Rp ${obat.harga}"),
                                  Text("Stok        : ${obat.stok}"),
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
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditDialog(context, index, obat);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                final updated = List<Obat>.from(_stok);
                                updated.removeAt(index);
                                stok = updated;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Tambah Stok Obat",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _showAddDialog(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, Obat obat) {
    final TextEditingController namaController = TextEditingController(
      text: obat.namaObat,
    );
    final TextEditingController stokController = TextEditingController(
      text: obat.stok.toString(),
    );
    final TextEditingController hargaController = TextEditingController(
      text: obat.harga.toString(),
    );

    KategoriObat? selectedKategori = kategoriList.firstWhere(
      (kat) => kat.idKategori == obat.idKategori,
      orElse: () => kategoriList.first,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Edit Stok Obat",
          style: TextStyle(color: Colors.teal),
        ),
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
              const SizedBox(height: 10),
              DropdownButtonFormField<KategoriObat>(
                value: selectedKategori,
                decoration: const InputDecoration(labelText: "Kategori"),
                items: kategoriList.map((kat) {
                  return DropdownMenuItem(
                    value: kat,
                    child: Text(kat.namaKategori),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKategori = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
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
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController stokController = TextEditingController();
    final TextEditingController hargaController = TextEditingController();

    KategoriObat? selectedKategori = kategoriList.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Tambah Stok Obat",
          style: TextStyle(color: Colors.teal),
        ),
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
              const SizedBox(height: 10),
              DropdownButtonFormField<KategoriObat>(
                value: selectedKategori,
                decoration: const InputDecoration(labelText: "Kategori"),
                items: kategoriList.map((kat) {
                  return DropdownMenuItem(
                    value: kat,
                    child: Text(kat.namaKategori),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKategori = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
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
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }
}
