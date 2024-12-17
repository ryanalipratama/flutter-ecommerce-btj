import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/produk.dart';
import '../Models/kategori.dart';
import '../Models/banner.dart';

class Apiservice{
  final String baseUrl = 'http://10.0.2.2:8000/api';

  // Fetch Kategori
  Future<List<Kategori>> fetchKategori() async {
  final response = await http.get(Uri.parse('$baseUrl/kategori'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse['data'] is List) { // Perubahan di sini
        final List<dynamic> kategoriList = jsonResponse['data']; // Perubahan di sini
        return kategoriList.map((data) => Kategori.fromJson(data)).toList();
      } else {
        throw Exception('Invalid or empty category response');
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch Produk
  Future<List<Produk>> fetchProduk() async {
    final response = await http.get(Uri.parse('$baseUrl/produk'));
    if (response.statusCode == 200) {
      print(response.body); // C
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['data'] != null) {
        final List<dynamic> produkList = jsonResponse['data'];
        return produkList.map((data) => Produk.fromJson(data)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch Banner
  Future<List<BannerModel>> fetchBannerModel() async{
   final response = await http.get(Uri.parse('$baseUrl/banner'));
    if (response.statusCode == 200) {
      print(response.body);
      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse['data'] is List) { // Perubahan di sini
        print(jsonResponse);
        final List<dynamic> bannerModelList = jsonResponse['data']; // Perubahan di sini
        print(bannerModelList);
        return bannerModelList.map((data) => BannerModel.fromJson(data)).toList();
      } else {
        throw Exception('Invalid or empty category response');
      }
    } else {
      throw Exception('Failed to load banner');
    }
  }

  // Create Transaction for Midtrans
  Future<String> createTransaction({
    required String token, 
    required String orderId,
    required int userId, 
    required String name,
    required String email,
    required String telepon,
    required String alamat,
    required int produkId, 
    required String namaProduk, 
    required double hargaProduk, 
    required int qty, 
    required String jasaPengiriman,
    required double grossAmount,
  }) async {
    final url = '$baseUrl/payment/create';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'order_id': orderId,
        'user_id': userId,
        'name': name,
        'email': email,
        'telepon': telepon,
        'alamat': alamat,
        'produk_id': produkId,
        'nama_produk': namaProduk,
        'harga_produk': hargaProduk,
        'qty': qty,
        'jasa_pengiriman': jasaPengiriman,
        'gross_amount': grossAmount,
      }),
    );

    final contentType = response.headers['content-type'] ?? '';
if (contentType.contains('application/json')) {
  final data = json.decode(response.body);
  if (data['snap_token'] != null) {
    return data['snap_token'];
  } else {
    throw Exception('Failed to retrieve Snap token');
  }
} else {
  print('Error Response: ${response.body}');
  throw Exception('Invalid API response. Expected JSON.');
}
  }
  
  // Payment Notification Handling
  Future<void> handlePaymentNotification(Map<String, dynamic> notificationData) async {
    final url = '$baseUrl/payment/notification';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(notificationData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to handle payment notification');
    }
  }
}