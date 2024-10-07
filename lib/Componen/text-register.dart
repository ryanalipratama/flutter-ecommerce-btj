import 'package:belajarflutter1/halaman/register.dart';
import 'package:flutter/material.dart';

class MyTextLink extends StatelessWidget {
  final Function()? onTap;

  const MyTextLink({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => Register())
        );
      },
      child: Text(
        'Daftar disini!',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
