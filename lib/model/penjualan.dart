class Penjualan {
  String _kodeObat;
  String _namaObat;
  String _namaKategori;
  int _jumlahTerjual;
  String _tanggal;

  Penjualan({
    required String kodeObat,
    required String namaObat,
    required String namaKategori,
    required int jumlahTerjual,
    required String tanggal,
  }) : _kodeObat = kodeObat,
       _namaObat = namaObat,
       _namaKategori = namaKategori,
       _jumlahTerjual = jumlahTerjual,
       _tanggal = tanggal;

  // Getter & Setter
  String get kodeObat => _kodeObat;
  set kodeObat(String value) => _kodeObat = value;

  String get namaObat => _namaObat;
  set namaObat(String value) => _namaObat = value;

  String get namaKategori => _namaKategori;
  set namaKategori(String value) => _namaKategori = value;

  int get jumlahTerjual => _jumlahTerjual;
  set jumlahTerjual(int value) => _jumlahTerjual = value;

  String get tanggal => _tanggal;
  set tanggal(String value) => _tanggal = value;

  // Polymorphism
  void tampilkanInfo() {
    print(
      "Penjualan Obat: $_namaObat ($_namaKategori) | Jumlah Terjual: $_jumlahTerjual | Tanggal: $_tanggal",
    );
  }
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
