import 'package:belajarflutter1/Models/kategori.dart';

class Produk {
  final int id;
  final String nama_produk;
  final int kategori_id;
  final double harga;
  final String deskripsi;
  final double jumlah;
  final String? gambar;
  final Kategori kategori;

  Produk({
    required this.id,
    required this.nama_produk,
    required this.kategori_id,
    required this.harga,
    required this.deskripsi,
    required this.jumlah,
    this.gambar,
    required this.kategori,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json["id"] is int ? json["id"] : int.parse(json["id"]),
      nama_produk: json["nama_produk"],
      kategori_id: json["kategori_id"] is int ? json["kategori_id"] : int.parse(json["kategori_id"]),
      harga: json["harga"] is double ? json["harga"] : double.parse(json["harga"]),
      deskripsi: json["deskripsi"],
      jumlah: json["jumlah"] is double ? json["jumlah"] : double.parse(json["jumlah"]),
      gambar: json["gambar"],
      kategori: Kategori.fromJson(json["kategori"]),
    );
  }
}
