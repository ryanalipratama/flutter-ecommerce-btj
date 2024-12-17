import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:belajarflutter1/halaman/bottom-navigation.dart';

class Pembayaran extends StatefulWidget {
  final String snapToken;

  const Pembayaran({Key? key, required this.snapToken}) : super(key: key);

  @override
  State<Pembayaran> createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  bool _isPaymentSuccessful = false; // Flag untuk status pembayaran

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains('http://example.com/')) { // Ganti dengan URL sukses pembayaran
              // Pembayaran berhasil, tampilkan halaman kosong
              setState(() {
                _isPaymentSuccessful = true; // Pembayaran sukses
              });

              // Tampilkan logo ceklis besar
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 150.0,
                        color: Colors.green,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Pembayaran berhasil! Silahkan konfirmasi dengan Admin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );

              // Navigasi kembali setelah beberapa detik
              Future.delayed(Duration(seconds: 3), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => navigasi(initialIndex: 2), // Ganti sesuai dengan halaman tujuan
                  ),
                );
              });
            } else if (url.contains('payment_failed_url')) { // URL untuk gagal
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 150.0,
                        color: Colors.red,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Pembayaran gagal!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
              // Navigasi kembali setelah beberapa detik
              Future.delayed(Duration(seconds: 3), () {
                Navigator.pop(context);
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse("https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}"));

    // Jika pembayaran berhasil, tampilkan halaman kosong
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: _isPaymentSuccessful
          ? Center(child: CircularProgressIndicator()) // Menampilkan loading setelah pembayaran berhasil
          : WebViewWidget(controller: controller), // Menampilkan WebView selama proses pembayaran
    );
  }
}
