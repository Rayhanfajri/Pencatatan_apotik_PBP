import 'kategoriobat.dart';

//inheritance
class Obat extends KategoriObat {
  String _kodeObat;
  String _namaObat;
  double _harga;
  int _stok;
  String _foto;

  Obat(
    String idKategori,
    String namaKategori,
    String deskripsi,
    this._kodeObat,
    this._namaObat,
    this._harga,
    this._stok,
    this._foto,
  ) : super(idKategori, namaKategori, deskripsi);

  // Getter & Setter
  String get kodeObat => _kodeObat;
  set kodeObat(String value) => _kodeObat = value;

  String get namaObat => _namaObat;
  set namaObat(String value) => _namaObat = value;

  double get harga => _harga;
  set harga(double value) => _harga = value;

  int get stok => _stok;
  set stok(int value) => _stok = value;

  String get foto => _foto;
  set foto(String value) => _foto = value;

  // Polymorphism
  @override
  void tampilkanInfo() {
    print(
      "Obat [$_kodeObat] $_namaObat | Harga: $_harga | Stok: $_stok | Kategori: $namaKategori | Foto: $_foto",
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
