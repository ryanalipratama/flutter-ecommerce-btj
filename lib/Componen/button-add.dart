import 'package:flutter/material.dart';

class MyButtonAdd extends StatelessWidget {
  final VoidCallback onTap;

  const MyButtonAdd({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: 360,
      height: 70,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(
        child: Text(
          "Tambahkan Produk Ke-Cart!",
          style: TextStyle(
            color: Color.fromARGB(255, 30, 94, 32),
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      )
    );
  }
}