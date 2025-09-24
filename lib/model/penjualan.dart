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
  Penjualan(namaObat: "Ibuprofen", jumlah: 7, tanggal: "2025-09-03"),
  Penjualan(namaObat: "Vitamin C", jumlah: 10, tanggal: "2025-09-04"),
  Penjualan(namaObat: "Antasida", jumlah: 4, tanggal: "2025-09-05"),
  Penjualan(namaObat: "Paracetamol", jumlah: 6, tanggal: "2025-09-06"),
  Penjualan(namaObat: "Amoxicillin", jumlah: 2, tanggal: "2025-09-07"),
  Penjualan(namaObat: "Ibuprofen", jumlah: 8, tanggal: "2025-09-08"),
  Penjualan(namaObat: "Vitamin C", jumlah: 12, tanggal: "2025-09-09"),
  Penjualan(namaObat: "Antasida", jumlah: 3, tanggal: "2025-09-10"),
  Penjualan(namaObat: "Paracetamol", jumlah: 9, tanggal: "2025-09-11"),
  Penjualan(namaObat: "Amoxicillin", jumlah: 5, tanggal: "2025-09-12"),
];
