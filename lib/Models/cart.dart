import 'package:belajarflutter1/Models/produk.dart';

class Cart {
  final int id;
  final int user_id;
  final int produk_id;
  int quantity;
  final Produk produk;
  bool isChecked;  // Properti isChecked hanya untuk aplikasi

  Cart({
    required this.id,
    required this.user_id,
    required this.produk_id,
    required this.quantity,
    required this.produk,
    this.isChecked = false,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json["id"],
      user_id: json["user_id"],
      produk_id: json["produk_id"],
      quantity: json["quantity"],
      produk: Produk.fromJson(json["produk"]),
      isChecked: false,
    );
  }
}
