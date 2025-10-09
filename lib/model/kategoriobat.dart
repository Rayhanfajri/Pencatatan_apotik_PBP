class KategoriObat {
  String _idKategori;
  String _namaKategori;
  String _deskripsi;

  KategoriObat(this._idKategori, this._namaKategori, this._deskripsi);

  String get idKategori => _idKategori;
  set idKategori(String value) => _idKategori = value;

  String get namaKategori => _namaKategori;
  set namaKategori(String value) => _namaKategori = value;

  String get deskripsi => _deskripsi;
  set deskripsi(String value) => _deskripsi = value;

  void tampilkanKategori() {
    print("[$_idKategori] $_namaKategori → $_deskripsi");
  }
}

List<KategoriObat> kategoriList = [
  KategoriObat("KAT01", "Antibiotik", "Obat untuk infeksi bakteri"),
  KategoriObat("KAT02", "Vitamin", "Suplemen kesehatan"),
  KategoriObat("KAT03", "Antipiretik", "Obat penurun demam"),
];
