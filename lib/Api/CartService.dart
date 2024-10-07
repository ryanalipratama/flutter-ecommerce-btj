import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/cart.dart';
import '../Models/produk.dart';
import '../Models/kategori.dart';

class CartService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Cart>> fetchCart(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/cart'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    List<Cart> carts = responseData.map((cartJson) {
      // Parsing data produk
      final Map<String, dynamic>? produkData = cartJson['produk'];

      // Memberikan nilai default untuk Produk ketika produkData bernilai null
      final Produk produk = produkData != null ? Produk(
        id: produkData['id'],
        nama_produk: produkData['nama_produk'],
        kategori_id: produkData['kategori_id'],
        harga: double.parse(produkData['harga']),
        deskripsi: produkData['deskripsi'],
        jumlah: double.parse(produkData['jumlah']),
        gambar: produkData['gambar'],
        // Menangani kategori yang mungkin null
        kategori: produkData['kategori'] != null ? Kategori.fromJson(produkData['kategori']) : Kategori(id: 0, nama_kategori: ''), // Berikan nilai default untuk id
      ) : Produk(
        id: 0, // Memberikan nilai default untuk id
        nama_produk: '',
        kategori_id: 0,
        harga: 0,
        deskripsi: '',
        jumlah: 0,
        gambar: '',
        kategori: Kategori(id: 0, nama_kategori: ''), // Berikan nilai default untuk id
      );

      // Parsing data cart
      return Cart(
        id: cartJson['id'],
        user_id: cartJson['user_id'],
        produk_id: cartJson['produk_id'],
        quantity: cartJson['quantity'],
        produk: produk,
      );
    }).toList();
    return carts;
  } else {
    throw Exception('Gagal memuat keranjang');
  }
}

  Future<void> addToCart(String token, int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'produk_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add item to cart');
    }
  }

  Future<void> removeFromCart(String token, int cartId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/$cartId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from cart');
    }
  }

  Future<void> updateCartItemQuantity(int cartItemId, int newQuantity, String token) async {
  final response = await http.put(
    Uri.parse('$baseUrl/cart/$cartItemId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'quantity': newQuantity,
    }),
  );

  if (response.statusCode == 200) {
    // Handle jika permintaan berhasil
    print('Item quantity updated successfully!');
  } else {
    // Handle jika terjadi kesalahan
    print('Failed to update item quantity: ${response.statusCode}');
    throw Exception('Failed to update item quantity');
  }
}


}
