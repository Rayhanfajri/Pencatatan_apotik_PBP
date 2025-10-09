class Penjualan {
  String namaObat;
  int jumlah;
  String tanggal;

  Penjualan({
    required this.namaObat,
    required this.jumlah,
    required this.tanggal,
  });

  @override
  String toString() {
    return "$namaObat ($jumlah) - $tanggal";
  }
}

List<Penjualan> penjualanList = [
  Penjualan(namaObat: "Paracetamol", jumlah: 5, tanggal: "2025-09-01"),
  Penjualan(namaObat: "Amoxicillin", jumlah: 3, tanggal: "2025-09-02"),
  Penjualan(namaObat: "Azithromycin", jumlah: 7, tanggal: "2025-09-03"),
  Penjualan(namaObat: "Vitamin D", jumlah: 10, tanggal: "2025-09-04"),
  Penjualan(namaObat: "Cetirizine", jumlah: 4, tanggal: "2025-09-05"),
  Penjualan(namaObat: "Ibuprofen", jumlah: 8, tanggal: "2025-09-08"),
  Penjualan(namaObat: "Vitamin C", jumlah: 12, tanggal: "2025-09-09"),
  Penjualan(namaObat: "Multivitamin", jumlah: 10, tanggal: "2025-09-07"),
  Penjualan(namaObat: "Dexamethasone", jumlah: 3, tanggal: "2025-09-10"),
];
