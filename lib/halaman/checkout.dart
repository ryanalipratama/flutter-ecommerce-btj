import 'package:belajarflutter1/Api/AuthService.dart';
import 'package:belajarflutter1/Api/ApiService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:belajarflutter1/Componen/button-bayar.dart';
import 'package:provider/provider.dart';
import 'bottom-navigation.dart';
import 'package:belajarflutter1/halaman/pembayaran.dart';
import 'package:belajarflutter1/Models/cart.dart' as CartModel;
import 'package:intl/intl.dart';
import 'package:belajarflutter1/Models/AuthModel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:belajarflutter1/Models/Struk.dart';

class Checkout extends StatefulWidget {
  final String? token;
  final List<CartModel.Cart> selectedItems;

  const Checkout({Key? key, required this.selectedItems, this.token}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late WebViewController _controller;
  final AuthService authService = AuthService();
  late Map<String, dynamic> userData;
  final TextEditingController idUserController = TextEditingController();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getProfile();
    _controller = WebViewController();
  }

  String generateOrderId() {
  // Menggunakan timestamp sebagai orderId yang unik
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void bayar() async {
    try {
      final apiService = Apiservice();

      if (widget.token == null || widget.token!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token tidak ditemukan')),
        );
        return;
      }

      if(widget.selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih produk terlebih dahulu!')),
        );
        print("errpr: Produk tidak dipilih");
        return;
      }

      // Ambil data dari form input
      String orderId = generateOrderId();
      int user_id = idUserController.text.isNotEmpty ? int.parse(idUserController.text) : 0;
      String name = namaLengkapController.text;
      String email = emailController.text;
      String telepon = teleponController.text;
      String alamat = alamatController.text;

      // Pastikan widget.selectedItems[0] berisi data yang benar
      var selectedItem = widget.selectedItems.isNotEmpty ? widget.selectedItems[0] : null;

      if (selectedItem != null) {
        // Ambil data produk dari selectedItem
        int produkId = selectedItem.produk_id; // ID produk
        String namaProduk = selectedItem.produk.nama_produk; // Nama produk
        double hargaProduk = selectedItem.produk.harga; // Harga produk
        int qty = selectedItem.quantity; // Kuantitas produk

        // Pastikan shippingCost sudah didefinisikan
        double shippingCost = 15000; // Ganti dengan nilai yang sesuai dengan aplikasi Anda

        // Hitung gross amount
        double grossAmount = hargaProduk * qty + shippingCost;

        // Panggil createTransaction
        final response = await apiService.createTransaction(
          token: widget.token!,
          orderId: orderId,
          userId: user_id,
          name: name,
          email: email,
          telepon: telepon,
          alamat: alamat,
          produkId: produkId,
          namaProduk: namaProduk,
          hargaProduk: hargaProduk,
          qty: qty,
          jasaPengiriman: selectedCourier ?? '',
          grossAmount: grossAmount,
        );

        // Validasi respons dari API
        if (response != null && response is String && response.isNotEmpty) {
          String snapToken = response;

          // Log snapToken untuk memastikan data diterima
          print('SnapToken diterima: $snapToken');

          // Navigasi ke halaman Pembayaran
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Pembayaran(snapToken: snapToken),
            ),
          );
        } else {
          // Tampilkan pesan jika snapToken tidak valid
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal membuat transaksi atau token tidak valid")),
          );
          print('Respons API tidak valid atau kosong: $response');
        }
      } else {
        // Tampilkan pesan jika tidak ada produk yang dipilih
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak ada produk yang dipilih")),
        );
        print('Error: Tidak ada produk yang dipilih');
      }
    } catch (e) {
      // Tangani kesalahan dan tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
      print('Error pada fungsi bayar: $e');
    }
  }



  void backtocart() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => navigasi(initialIndex: 1),
      ),
    );
  }

  String? selectedCourier;
  List<String> couriers = ['JNE', 'TIKI', 'POS Indonesia', 'J&T Express'];


  Future<void> _getProfile() async {
    final authToken = Provider.of<UserModel>(context, listen: false).token;
    if (authToken == null) return;
    try {
      final result = await authService.getProfile(authToken);
      setState(() {
        userData = result['data'];
        idUserController.text = userData['id'].toString(); 
        namaLengkapController.text = userData['name'];
        emailController.text = userData['email'];
        teleponController.text = userData['telepon'];
        alamatController.text = userData['alamat'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } 
  }

  Widget build(BuildContext context) {
    double totalAmount = widget.selectedItems.fold(0, (sum, item) {
      return sum + (item.produk.harga * item.quantity);
    });

    // Format Rupiah
    String formatRupiah(double amount) {
      final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID');
      return formatCurrency.format(amount);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Checkout",
            style: TextStyle(
                color: Color.fromARGB(255, 30, 94, 32),
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: backtocart,
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100), // To avoid overlapping button
              child: Column(
                children: [

                  // Id Pengguna
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 240, 240, 240),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Id Pengguna",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: double.infinity, // Menjadikan Card selebar mungkin
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      idUserController.text,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Nama 
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 240, 240, 240),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Nama Penerima",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: double.infinity, // Menjadikan Card selebar mungkin
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      namaLengkapController.text,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 10),

                  // Email
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 240, 240, 240),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Email Penerima",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: double.infinity, // Menjadikan Card selebar mungkin
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      emailController.text,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  
                  // Telepon
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 240, 240, 240),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "No Telepon Penerima",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: double.infinity, // Menjadikan Card selebar mungkin
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      teleponController.text,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 10),
                  
                  // Alamat
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 240, 240, 240),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Pastikan Alamat anda benar!",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alamatController.text, 
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Produk
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 240, 240, 240),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Produk Yang dipesan :",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true, // Prevent overflow, allow ListView to take limited space
                            itemCount: widget.selectedItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = widget.selectedItems[index];
                              final totalPrice = cartItem.produk.harga * cartItem.quantity;

                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      cartItem.produk.gambar != null
                                        ? Image.network(
                                            'http://10.0.2.2:8000/${cartItem.produk.gambar}',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(width: 60, height: 60), 
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem.produk.nama_produk, // Display product name
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          Text("${formatRupiah (cartItem.produk.harga)}"),
                                          Text("Jumlah: ${cartItem.quantity}"),
                                          Text(
                                            "Total Harga: ${formatRupiah (totalPrice)}",
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Ekspedisi
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 240, 240, 240),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Pilih Jasa Pengiriman:",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: DropdownButton<String>(
                                    value: selectedCourier,
                                    hint: Text('Pilih Jasa Pengiriman'),
                                    isExpanded: true,
                                    items: couriers.map((String courier) {
                                      return DropdownMenuItem<String>(
                                        value: courier,
                                        child: Text(courier),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCourier = newValue;
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    "Biaya Ongkos Kirim :",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text("Estimasi Waktu :"),
                                      Spacer(),
                                      Text("1-2 Hari"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, bottom: 16, right: 16),
                                  child: Row(
                                    children: [
                                      Text("Total Biaya Ongkos Kirim :"),
                                      Spacer(),
                                      Text(
                                        "Rp. 15.000",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Rincian Biaya
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(255, 240, 240, 240),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Rincian Biaya :",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Total Belanja :"),
                                      Spacer(),
                                      Text("${formatRupiah(totalAmount)}"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Total Ongkir :"),
                                      Spacer(),
                                      Text("Rp. 15.000"),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      Text("Total Pembayaran :"),
                                      Spacer(),
                                      Text(
                                        "${formatRupiah(totalAmount + 15000)}",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),

            // Tombol Bayar
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color.fromARGB(255, 240, 240, 240),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Total Pembayaran:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Spacer(),
                        Text(
                          "${formatRupiah (totalAmount + 15000)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.red),
                        ),
                      ],
                    ),
                    MyButtonBayar(onTap: bayar),
                  ],
                ),
              ),
            )

          ],
        ),
      );
  }
}
