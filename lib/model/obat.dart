import 'kategoriobat.dart';

class Obat extends KategoriObat {
  String kodeObat;
  String namaObat;
  double harga;
  int stok;
  String foto;

  Obat(
    String idKategori,
    String namaKategori,
    String deskripsi,
    this.kodeObat,
    this.namaObat,
    this.harga,
    this.stok,
    this.foto,
  ) : super(idKategori, namaKategori, deskripsi);

  void tampilkanInfo() {
    print(
      "Obat [$kodeObat] $namaObat | Harga: $harga | Stok: $stok | Kategori: $namaKategori | Foto: $foto",
    );
  }
}

List<Obat> stokObatList = [
  Obat(
    kategoriList[0].idKategori,
    kategoriList[0].namaKategori,
    kategoriList[0].deskripsi,
    "OB001",
    "Amoxicillin",
    5000,
    15,
    "assets/images/amoxicillin.jpg",
  ),
  Obat(
    kategoriList[0].idKategori,
    kategoriList[0].namaKategori,
    kategoriList[0].deskripsi,
    "OB002",
    "Azithromycin",
    15000,
    10,
    "assets/images/Azithromycin.jpeg",
  ),
  Obat(
    kategoriList[0].idKategori,
    kategoriList[0].namaKategori,
    kategoriList[0].deskripsi,
    "OB003",
    "Dexamethasone",
    13000,
    45,
    "assets/images/Dexamethasone.jpg",
  ),
  Obat(
    kategoriList[1].idKategori,
    kategoriList[1].namaKategori,
    kategoriList[1].deskripsi,
    "OB004",
    "Vitamin C",
    3000,
    25,
    "assets/images/VitaminC.jpg",
  ),
  Obat(
    kategoriList[1].idKategori,
    kategoriList[1].namaKategori,
    kategoriList[1].deskripsi,
    "OB005",
    "Vitamin D",
    5000,
    55,
    "assets/images/vitamind.jpg",
  ),
  Obat(
    kategoriList[1].idKategori,
    kategoriList[1].namaKategori,
    kategoriList[1].deskripsi,
    "OB006",
    "Multivitamin",
    7000,
    30,
    "assets/images/Multivitamin.jpg",
  ),

  Obat(
    kategoriList[2].idKategori,
    kategoriList[2].namaKategori,
    kategoriList[2].deskripsi,
    "OB007",
    "Paracetamol",
    20000,
    20,
    "assets/images/paracetamol.png",
  ),
  Obat(
    kategoriList[2].idKategori,
    kategoriList[2].namaKategori,
    kategoriList[2].deskripsi,
    "OB009",
    "Ibuprofen",
    9000,
    15,
    "assets/images/ibuprofen.jpg",
  ),
  Obat(
    kategoriList[2].idKategori,
    kategoriList[2].namaKategori,
    kategoriList[2].deskripsi,
    "OB010",
    "Cetirizine",
    4000,
    40,
    "assets/images/Cetirizine.png",
  ),
];
