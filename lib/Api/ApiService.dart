import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/produk.dart';
import '../Models/kategori.dart';
import '../Models/banner.dart';

class Apiservice{
  final String baseUrl = 'http://10.0.2.2:8000/api';
  

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

  
}