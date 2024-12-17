import 'package:flutter/material.dart';

class MyButtonSudahBayar extends StatelessWidget {
  final Function()? onTap;

  const MyButtonSudahBayar({
    super.key, 
    required this.onTap,
  });

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
          color: Color.fromARGB(255, 30, 94, 32),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "Saya Sudah Bayar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
