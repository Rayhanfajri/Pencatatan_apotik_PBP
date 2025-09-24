class KategoriObat {
  String idKategori;
  String namaKategori;
  String deskripsi;

  KategoriObat(this.idKategori, this.namaKategori, this.deskripsi);

  void tampilkanKategori() {
    print("[$idKategori] $namaKategori → $deskripsi");
  }
}

List<KategoriObat> kategoriList = [
  KategoriObat("KAT01", "Antibiotik", "Obat untuk infeksi bakteri"),
  KategoriObat("KAT02", "Vitamin", "Suplemen kesehatan"),
  KategoriObat("KAT03", "Antipiretik", "Obat penurun demam"),
];
