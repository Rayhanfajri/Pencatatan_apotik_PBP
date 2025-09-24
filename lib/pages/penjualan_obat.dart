import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _penjualan = List<Penjualan>.from(widget.penjualan);
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
            top: -40,
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
                  itemCount: _penjualan.length,
                  itemBuilder: (context, index) {
                    final item = _penjualan[index];
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
                        title: Text(
                          item.namaObat,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        subtitle: Text(
                          "Jumlah: ${item.jumlah}\nTanggal: ${item.tanggal}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        onTap: () {
                          _showDetailDialog(context, item);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditDialog(context, index, item);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _penjualan.removeAt(index);
                                });
                                widget.onUpdate(_penjualan);
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
                    "Tambah Penjualan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _showAddDialog(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Penjualan item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            Text("Tanggal: ${item.tanggal}"),
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

  void _showEditDialog(BuildContext context, int index, Penjualan item) {
    final namaController = TextEditingController(text: item.namaObat);
    final jumlahController = TextEditingController(
      text: item.jumlah.toString(),
    );
    final tanggalController = TextEditingController(text: item.tanggal);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Penjualan"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Obat"),
              ),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah"),
              ),
              TextFormField(
                controller: tanggalController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Tanggal"),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.tryParse(item.tanggal) ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    tanggalController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
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
            onPressed: () {
              setState(() {
                _penjualan[index] = Penjualan(
                  namaObat: namaController.text,
                  jumlah: int.tryParse(jumlahController.text) ?? item.jumlah,
                  tanggal: tanggalController.text,
                );
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

  void _showAddDialog(BuildContext context) {
    final namaController = TextEditingController();
    final jumlahController = TextEditingController();
    final tanggalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Penjualan"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Obat"),
              ),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah"),
              ),
              TextFormField(
                controller: tanggalController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Tanggal"),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    tanggalController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
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
            onPressed: () {
              if (namaController.text.isNotEmpty &&
                  jumlahController.text.isNotEmpty &&
                  tanggalController.text.isNotEmpty) {
                setState(() {
                  _penjualan.add(
                    Penjualan(
                      namaObat: namaController.text,
                      jumlah: int.tryParse(jumlahController.text) ?? 0,
                      tanggal: tanggalController.text,
                    ),
                  );
                });
                widget.onUpdate(_penjualan);
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
