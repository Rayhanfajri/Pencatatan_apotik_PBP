class Penjualan {
  String kodeObat;
  String namaObat;
  String namaKategori;
  int jumlahTerjual;
  String tanggal;

  Penjualan({
    required this.kodeObat,
    required this.namaObat,
    required this.namaKategori,
    required this.jumlahTerjual,
    required this.tanggal,
  });
}

List<Penjualan> penjualanList = [
  Penjualan(
    kodeObat: "OB001",
    namaObat: "Amoxicillin",
    namaKategori: "Antibiotik",
    jumlahTerjual: 5,
    tanggal: "2025-10-01",
  ),
  Penjualan(
    kodeObat: "OB002",
    namaObat: "Azithromycin",
    namaKategori: "Antibiotik",
    jumlahTerjual: 3,
    tanggal: "2025-10-02",
  ),
  Penjualan(
    kodeObat: "OB003",
    namaObat: "Dexamethasone",
    namaKategori: "Antibiotik",
    jumlahTerjual: 4,
    tanggal: "2025-10-03",
  ),
  Penjualan(
    kodeObat: "OB004",
    namaObat: "Vitamin C",
    namaKategori: "Vitamin",
    jumlahTerjual: 10,
    tanggal: "2025-10-04",
  ),
  Penjualan(
    kodeObat: "OB005",
    namaObat: "Vitamin D",
    namaKategori: "Vitamin",
    jumlahTerjual: 8,
    tanggal: "2025-10-05",
  ),
  Penjualan(
    kodeObat: "OB006",
    namaObat: "Multivitamin",
    namaKategori: "Vitamin",
    jumlahTerjual: 12,
    tanggal: "2025-10-06",
  ),
  Penjualan(
    kodeObat: "OB007",
    namaObat: "Paracetamol",
    namaKategori: "Analgesik",
    jumlahTerjual: 7,
    tanggal: "2025-10-07",
  ),
  Penjualan(
    kodeObat: "OB009",
    namaObat: "Ibuprofen",
    namaKategori: "Analgesik",
    jumlahTerjual: 5,
    tanggal: "2025-10-08",
  ),
  Penjualan(
    kodeObat: "OB010",
    namaObat: "Cetirizine",
    namaKategori: "Analgesik",
    jumlahTerjual: 6,
    tanggal: "2025-10-09",
  ),
];
