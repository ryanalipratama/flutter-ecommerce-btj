import 'package:belajarflutter1/Componen/button-add.dart';
import 'package:flutter/material.dart';
import 'package:belajarflutter1/Models/produk.dart';
import 'package:belajarflutter1/Api/CartService.dart';
import 'package:belajarflutter1/halaman/bottom-navigation.dart';
import 'package:intl/intl.dart';

class DetailProduk extends StatefulWidget {
  final String token;
  final Produk produk;
  const DetailProduk({super.key, required this.produk, required this.token});

  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  final CartService _cartService = CartService();
  int quantity = 1; // Default quantity

  void addToCart() async {
    try {
      await _cartService.addToCart(
        widget.token,
        widget.produk.id, 
        quantity
      );
      print('Produk berhasil ditambahkan ke cart!');
      // Tambahkan pernyataan atau tindakan lain sesuai kebutuhan setelah menambahkan produk ke cart
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => navigasi(initialIndex: 1), // Pastikan Navigasi menampilkan halaman cart
        ),
      );

    } catch (e) {
      print('Gagal menambahkan produk ke cart: $e');
      // Tambahkan pernyataan atau tindakan lain sesuai kebutuhan jika penambahan ke cart gagal
    }
  }
  // Format Rupiah
    String formatRupiah(double amount) {
      final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID');
      return formatCurrency.format(amount);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: Text(
            "Detail Produk",
            style: TextStyle(
              color: Color.fromARGB(255, 30, 94, 32),
              fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
      ),

      body: Column(
        children: 
        [
          // Bagian Atas Putih
          Container(
            color: Colors.white,
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: widget.produk.gambar != null && widget.produk.gambar!.isNotEmpty
                ? Image.network(
                  'http://10.0.2.2:8000/${widget.produk.gambar!}',
                  fit: BoxFit.cover,
                  )
                : SizedBox()
          ),

          // Bagian Bawah Hijau
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 30, 94, 32),
                  borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), // Sudut bulat kiri atas
                  topRight: Radius.circular(25),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                  // Nama, Harga, Deskripsi
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: 
                      [
                        // Nama Produk
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 25),
                          child: Text(
                            widget.produk.nama_produk,
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ), 

                        // Harga Produk
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 3),
                          child: Text(
                            "${formatRupiah(widget.produk.harga)}",
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 35,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),  

                        // Deskripsi Produk
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Text(
                            textAlign: TextAlign.justify,
                            widget.produk.deskripsi,
                            style: TextStyle(   
                              color: Colors.white, 
                              fontSize: 13,
                              
                            ),
                          ),
                        ),  

                      ],
                    ),
                    )
                    
                  ),

                  // Button Tambah ke Cart
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20), // Add spacing at the bottom if needed
                      child: MyButtonAdd(onTap: addToCart),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
  
    );
  }
}
